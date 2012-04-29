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


module.exports = Message