redis = require('redis').createClient()
_	  = require('underscore')
BaseModel = require('./base')

class User extends BaseModel
	@key: ->
		"User:#{process.env.NODE_ENV}"

	@generateId: (text) ->
		text.replace /\s/g, '-'

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

	defaults:
		active: true
		isMod: false
		ips: []
		isMuted: false
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

	makeMod: ->
		@isMod = true
		@save()

	deMod: ->
		@isMod = false
		@save()

	mute: ->
		@isMuted = true
		@mutedSince = new Date
		@save()

	unMute: ->
		@isMuted = false
		@mutedSince = null
		@save()

	destroy: (callback) ->
		redis.hdel User.key(), @id, (err) ->
			callback err if callback

module.exports = User
