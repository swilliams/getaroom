redis = require('redis').createClient()

class User
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

	defaults:
		active: true

	constructor: (attributes) ->
		@setDefaults()
		@[key] = value for key,value of attributes

	setDefaults: ->
		@[key] = value for key,value of @defaults

	generateId: ->
		if not @id and @name
			@id = User.generateId @name

	save: (callback) ->
		@generateId()
		redis.hset User.key(), @id, JSON.stringify(@), (err, resp) =>
			if callback? then callback null, @

	logout: (callback) ->
		@active = false


	destroy: (callback) ->
		redis.hdel User.key(), @id, (err) ->
			callback err if callback

module.exports = User
