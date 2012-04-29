jQuery ->
	class LoginView extends Backbone.View
		el: '#login_container'
		initialize: ->

		events: 
			'click #logout' : 'logout'

		render: ->
			@

		getForm: ->
			@$('form')

		logout: (ev) ->
			ev.preventDefault()
			form = @getForm()
			form.submit()

	class ChatMasterView extends Backbone.View
		initialize: ->
			@setupUserView()
			@setupChatEntry()
			@setupChatView()

		preloadUsers: (users) ->
			@userView.collection.reset users

		setupUserView: ->
			@userView = new UserGridView collection: new app.Users
			@userView.render()

		setupChatEntry: ->
			@chatEntryView = new ChatEntryView
			@chatEntryView.render()

		setupChatView: ->
			@chatView = new ChatView collection: new app.Messages
			@chatView.render()

	class ChatView extends Backbone.View
		el: '#chat'
		subviews: null

		initialize: ->
			@subviews = []
			window.foo = @collection
			@collection.bind 'add', @addMessage, @


		render: ->
			@

		addMessage: (msg) ->
			view = @createMessageView msg
			@subviews.push view
			@$el.append view.render().el

		createMessageView: (msg) ->
			view = new MessageView model:msg
			view

	class MessageView extends Backbone.View
		initialize: ->

		render: ->
			template = "<div class=\"message\">#{@model.get('user')}: #{@model.get('content')}</div>"
			@$el.html template
			@

	class ChatEntryView extends Backbone.View
		el: '#chat_entry'
		initialize: ->

		events:
			'submit form' : 'addChat'

		render: ->
			@

		getText: ->
			@$('input[name=chat]').val()

		addChat: (ev) ->
			ev.preventDefault()
			newMessage = new app.Message content: @getText()
			newMessage.save()

	class UserGridView extends Backbone.View
		el: '#users'

		initialize: ->
			@collection.bind 'reset', @render, @
			@collection.bind 'add', @addUser, @
			@collection.bind 'remove', @render, @

		render: ->
			@$el.empty()
			@addUser user for user in @collection.models

		addUser: (user) ->
			view = new UserView model: user
			@$el.append view.render().el

	class UserView extends Backbone.View
		className: 'user'

		initialize: ->

		render: ->
			@$el.html @model.get('name')
			@



	@app = window.app ? {}
	@app.LoginView = LoginView
	@app.UserGridView = UserGridView
	@app.ChatMasterView = ChatMasterView