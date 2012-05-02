class Users extends Backbone.Collection
	type: app.User

	initialize: ->

	setupSocket: ->
		socket = io.connect '/'
		socket.on "user:loggedIn", (user) =>
			@add new App.User(user)
		socket.on "user:loggedOut", (user) =>
			@remove user.id

class Messages extends Backbone.Collection
	type: app.Message

	initialize: ->

	setupSocket: ->
		socket = io.connect '/'
		socket.on "msg:received", (msg) =>
			@add new app.Message(msg)

@app = window.app ? {}
@app.Messages = new Messages
@app.Users = new Users