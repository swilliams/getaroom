class BaseModel
	defaults: {}

	constructor: (attributes) ->
		@setDefaults()
		@[key] = value for key,value of attributes

	setDefaults: ->
		@[key] = value for key,value of @defaults


module.exports = BaseModel
