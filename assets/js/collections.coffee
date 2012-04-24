class Users extends Backbone.Collection
	type: app.User

	initialize: ->

class Messages extends Backbone.Collection
	type: app.Message

	initialize: ->

@app = window.app ? {}
@app.Messages = Messages
@app.Users = new Users