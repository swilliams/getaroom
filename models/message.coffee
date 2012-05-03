redis = require('redis').createClient()
_	  = require('underscore')
BaseModel = require('./base') 

class Message extends BaseModel
	@key: ->
		"Message:#{process.env.NODE_ENV}"

	defaults:
		content: ''

	constructor: (@userId, attributes) ->
		super attributes
		unless @userId? then throw "A Message needs a user id" 

	setDefaults: ->
		super()
		@timestamp = new Date() unless @timestamp?

	generateId: (callback) ->
		unless @id? 
			key = "ids:Message:#{process.env.NODE_ENV}"
			redis.incr key, (err, id) =>
				@id = "message:#{id}"
				callback()
		else
			callback()

	validate: ->
		valid = []
		maxContentLength = 280
		if @content.length > maxContentLength then valid.push message: "Content length must be less than 280 characters."
		if valid.length == 0 then null else valid

	save: (callback) ->
		if (err = @validate())?
			callback err, null
			return
		@generateId =>
			redis.hset Message.key(), @id, JSON.stringify(@), (err, resp) =>
				if callback? then callback err, @


module.exports = Message