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
			return null if json is null
			user = new User JSON.parse(json)
			callback null, user

	@all: (callback) ->
		redis.hgetall User.key(), (err, objects) ->
			users = []
			for key, value of objects
				user = new User JSON.parse(value)
				users.push user
			callback null, users

	constructor: (attributes) ->
		@[key] = value for key,value of attributes

	generateId: ->
		if not @id and @name
			@id = User.generateId @name

	save: (callback) ->
		@generateId()
		redis.hset User.key(), @id, JSON.stringify(@), (err, resp) =>
			callback null, @

	destroy: (callback) ->
		redis.hdel User.key(), @id, (err) ->
			callback err if callback

module.exports = User
