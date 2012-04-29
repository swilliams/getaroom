redis = require('redis').createClient()
_	  = require('underscore')
BaseModel = require('./base') 

class Message extends BaseModel
	@key: ->
		"Message:#{process.env.NODE_ENV}"

	defaults:
		content: ''
		timestamp: new Date

	constructor: (@userId, attributes) ->
		super attributes
		unless @userId? then throw "A Message needs a user id" 

	generateId: (callback) ->
		unless @id? 
			key = "ids:Message:#{process.env.NODE_ENV}"
			redis.incr key, (err, id) =>
				@id = "message:#{id}"
				callback()
		else
			callback()


	save: (callback) ->
		@generateId =>
			redis.hset Message.key(), @id, JSON.stringify(@), (err, resp) ->
				if callback? then callback err, @


module.exports = Message