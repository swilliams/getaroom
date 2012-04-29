class Users extends Backbone.Collection
	type: app.User

	initialize: ->
		@setupSocket()

	setupSocket: ->
		socket = io.connect '/'
		socket.on "user:loggedIn", (user) =>
			@add user
		socket.on "user:loggedOut", (user) =>
			@remove user.id

class Messages extends Backbone.Collection
	type: app.Message

	initialize: ->
		@setupSocket()

	setupSocket: ->
		socket = io.connect '/'
		socket.on "msg:received", (msg) =>
			@add new app.Message(msg)

@app = window.app ? {}
@app.Messages = Messages
@app.Users = Users