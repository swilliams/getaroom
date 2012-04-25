class User extends Backbone.Model
	initialize: ->

class Message extends Backbone.Model
	url: '/chat'

	initialize: ->

	save: ->
		super()


@app = window.app ? {}
@app.Message = Message