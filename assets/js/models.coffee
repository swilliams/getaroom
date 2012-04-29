class User extends Backbone.Model
	initialize: ->

class Message extends Backbone.Model
	url: '/chat'

	initialize: ->

	toJSON: ->
		json = super()
		d = new Date json.timestamp
		json.formattedTimestamp = "#{d.getHours()}:#{d.getMinutes()}:#{d.getSeconds()}"
		json

@app = window.app ? {}
@app.User = User
@app.Message = Message