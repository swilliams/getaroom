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
			@chatEntryView.focus()

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
			@scrollToBottom()

		createMessageView: (msg) ->
			view = new MessageView model:msg
			view

		scrollToBottom: ->
			rowHeight = _.reduce @$el.children(), (memo, elem) -> 
				memo + $(elem).height()
			, 0
			@$el.scrollTop rowHeight

	class MessageView extends Backbone.View
		template: Handlebars.compile $('#message_template').html() ? ''
		className: 'row message'

		initialize: ->

		render: ->
			@$el.html @template(@model.formatted())
			if @model.isMention() then @$el.addClass 'mentioned'
			if @model.isUsersMessage() then @$el.addClass 'self_message'
			@

	class ChatEntryView extends Backbone.View
		el: '#chat_entry'
		initialize: ->

		events:
			'submit form' : 'addChat'
			'keypress input[name=chat]' : 'keyPressed'

		render: ->
			@

		focus: ->
			@$('input[name=chat]').focus()

		getText: ->
			@$('input[name=chat]').val()

		setText: (text) ->
			@$('input[name=chat]').val text

		clearText: ->
			@$('input[name=chat]').val ''

		displayLastMessage: ->
			@setText @lastMessageEntered

		keyPressed: (ev) ->
			up = 38
			tab = 9
			if ev.keyCode == up then @displayLastMessage()

		addChat: (ev) ->
			ev.preventDefault()
			@lastMessageEntered = @getText()
			newMessage = new app.Message content: @lastMessageEntered
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