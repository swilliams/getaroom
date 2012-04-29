class User extends Backbone.Model
	initialize: ->

class Message extends Backbone.Model
	url: '/chat'

	initialize: ->

	_getUserById: ->
		app.Users.get @get('userId')

	formatted: ->
		console.log @
		json = @toJSON()
		d = new Date json.timestamp
		json.formattedTimestamp = "#{d.getHours()}:#{d.getMinutes()}:#{d.getSeconds()}"
		user = @_getUserById()
		json.userName = user.get 'name'
		json

@app = window.app ? {}
@app.User = User
@app.Message = Message