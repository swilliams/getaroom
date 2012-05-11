redis = require('redis').createClient()
_	  = require('underscore')
BaseModel = require('./base')

class User extends BaseModel
	@key: ->
		"User:#{process.env.NODE_ENV}"

	@sessionKey: ->
		"UserSession:#{process.env.NODE_ENV}"

	@generateId: (text) ->
		text.replace /\s/g, '-'

	@getIdBySession: (sessionId, callback) ->
		redis.hget User.sessionKey, sessionId, (err, userId) ->
			callback null, userId

	@getByUsername: (name, callback) ->
		id = User.generateId name
		User.getById id, callback

	@getById: (id, callback) ->
		redis.hget User.key(), id, (err, json) ->
			user = null
			unless json is null
				user = new User JSON.parse(json)
			callback null, user

	@all: (callback) ->
		redis.hgetall User.key(), (err, objects) ->
			users = []
			for key, value of objects
				user = new User JSON.parse(value)
				users.push user
			callback null, users

	@active: (callback) ->
		User.all (err, users) ->
			activeUsers = _.filter users, (u) -> u.active
			callback null, activeUsers

	@fromTwitter: (accessToken, accessTokenSecret, twattributes) ->
		attrs = 
			name: twattributes.screen_name
			realName: twattributes.name
			location: twattributes.location
			imageUrl: twattributes.profile_image_url
			url: twattributes.url
			accessToken: accessToken
			accessTokenSecret: accessTokenSecret
		new User attrs

	defaults:
		active: true
		isMod: false
		ips: []
		mutedSince: null
		lastLogin: null

	generateId: ->
		if not @id and @name
			@id = User.generateId @name

	toClientObject: ->
		keys = ['name', 'isMod', 'lastLogin', 'id']
		_.pick @, keys

	save: (callback) ->
		@generateId()
		redis.hset User.key(), @id, JSON.stringify(@), (err, resp) =>
			if callback? then callback null, @

	logout: (callback) ->
		@active = false
		@save callback

	login: (callback) ->
		@active = true
		@lastLogin = new Date
		@save callback

	addIp: (address) ->
		unless _.find(@ips, (ip) -> ip == address)
			@ips.push address
			@save()

	hasIp: (address) ->
		_.any @ips, (ip) -> ip == address

	makeMod: ->
		@isMod = true
		@save()

	deMod: ->
		@isMod = false
		@save()

	mute: ->
		@isMuted = true
		@mutedSince = new Date

	unMute: ->
		@isMuted = false
		@mutedSince = null

	update: (attributes, whosAsking, callback) ->
		if whosAsking.id == @id
			@name = attributes.name if attributes.name?

		if whosAsking.isMod
			if attributes.isMuted and not @isMod then @mute() else @unMute()

		@save callback


	destroy: (callback) ->
		redis.hdel User.key(), @id, (err) ->
			callback err if callback

module.exports = User
