class User extends Backbone.Model
	urlRoot: '/user'

	initialize: ->

	formatted: ->
		json = @toJSON()
		d = new Date json.lastLogin
		json.formattedLogin = app.util.formatDate d
		json

class Message extends Backbone.Model
	url: '/chat'
	defaults:
		originatedFromHere: false

	initialize: ->

	_getUserById: ->
		app.Users.get @get('userId')

	isMention: ->
		userName = window.app.currentUser.name
		result = @get('content').indexOf userName
		result >= 0

	isUsersMessage: ->
		window.app.currentUser.id == @get('userId')

	formatted: ->
		json = @toJSON()
		d = new Date json.timestamp
		json.formattedTimestamp = app.util.formatDate d
		json.fullTimestamp = ""
		user = @_getUserById()
		json.userName = user.get 'name'
		json

@app = window.app ? {}
@app.User = User
@app.Message = Message