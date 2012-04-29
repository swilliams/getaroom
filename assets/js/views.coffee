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
			@userView = new UserGridView collection: app.Users
			@userView.render()

		setupChatEntry: ->
			@chatEntryView = new ChatEntryView
			@chatEntryView.render()

		setupChatView: ->
			@chatView = new ChatView collection: app.Messages
			@chatView.render()

	class ChatView extends Backbone.View
		el: '#chat'
		subviews: null

		initialize: ->
			@collection.setupSocket()
			@subviews = []
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
		template: Handlebars.compile $('#message_template').html() ? ''

		initialize: ->

		render: ->
			window.Foo = @model
			@$el.html @template(@model.toJSON())
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

		clearText: ->
			@$('input[name=chat]').val ''

		addChat: (ev) ->
			ev.preventDefault()
			newMessage = new app.Message content: @getText()
			@clearText()
			newMessage.save()

	class UserGridView extends Backbone.View
		el: '#users'

		initialize: ->
			@collection.setupSocket()
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
		className: 'row user'
		template: Handlebars.compile $('#user_row_template').html()

		initialize: ->

		render: ->
			@$el.html @template(@model.toJSON())
			@



	@app = window.app ? {}
	@app.LoginView = LoginView
	@app.UserGridView = UserGridView
	@app.ChatMasterView = ChatMasterView