redis = require('redis').createClient()

class User
	@key: ->
		"User:#{process.env.NODE_ENV}"

	constructor: (attributes) ->
		@[key] = value for key,value of attributes

	generateId: ->
		if not @id and @name
			@id = @name.replace /\s/g, '-'

	save: (callback) ->
		@generateId()
		redis.hset Pie.key(), @id, JSON.stringify(@), (err, resp) =>
			callback null, @

	destroy: (callback) ->
		redis.hdel Pie.key(), @id, (err) ->
			callback err if callback

module.exports = User
