class User extends Backbone.Model
	initialize: ->

class Message extends Backbone.Model
	url: '/chat'

	initialize: ->

	save: ->
		console.log 'save' + @get('text')
		super()


@app = window.app ? {}
@app.Message = Message