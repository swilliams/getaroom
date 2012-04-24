class Users extends Backbone.Collection
	type: app.User

	initialize: ->

class Messages extends Backbone.Collection
	type: app.Message

	initialize: ->
		@setupSocket()

	setupSocket: ->
		socket = io.connect '/'
		socket.on "msg:received", (msg) =>
			console.log msg
			@add msg

@app = window.app ? {}
@app.Messages = Messages
@app.Users = new Users