class Users extends Backbone.Collection
	model: app.User

	initialize: ->

	setupSocket: ->
		socket = io.connect '/'
		socket.on "user:loggedIn", (user) =>
			@add new app.User(user)
		socket.on "user:loggedOut", (user) =>
			@remove user.id

class Messages extends Backbone.Collection
	model: app.Message

	initialize: ->

	setupSocket: ->
		socket = io.connect '/'
		socket.on "msg:received", (msg) =>
			@add new app.Message(msg)

@app = window.app ? {}
@app.Messages = new Messages
@app.Users = new Users