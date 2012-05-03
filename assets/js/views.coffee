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
			newMessage = @createMessage()
			@chatEntryView = new ChatEntryView model: newMessage
			@chatEntryView.render()
			@chatEntryView.focus()

		setupChatView: ->
			@chatView = new ChatView collection: app.Messages
			@chatView.render()

		addMessage: (msg) ->
			msg.set originatedFromHere: true
			@chatView.renderMessage msg
			@chatView.model = @createMessage()

		createMessage: ->
			newMessage = new app.Message
			newMessage.bind 'change:content', @addMessage, @
			newMessage


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
			if msg.get('originatedFromHere') or not msg.isUsersMessage()
				@renderMessage msg

		renderMessage: (msg) ->
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
			'submit form' : 'addMessage'
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

		addMessage: (ev) ->
			ev.preventDefault()
			@lastMessageEntered = @getText()
			@clearText()
			@model.save content: @lastMessageEntered, userId: app.currentUser.id, timestamp: new Date, originatedFromHere: true

	class UserGridView extends Backbone.View
		el: '#users'

		initialize: ->
			@collection.setupSocket()
			@collection.bind 'reset', @render, @
			@collection.bind 'add', @addUser, @
			@collection.bind 'remove', @render, @
			@subviews = []

		render: ->
			@$el.empty()
			@addUser user for user in @collection.models

		addUser: (user) ->
			view = new UserView model: user
			view.bind 'popover:shown', @hideActivePopover, @
			@subviews.push view
			@$el.append view.render().el

		hideActivePopover: (selectedPopover) ->
			if @activePopover? and @activePopover != selectedPopover
				@activePopover.hide()
			@activePopover = selectedPopover


	class UserView extends Backbone.View
		className: 'row user'
		template: Handlebars.compile $('#user_row_template').html()

		initialize: ->

		events:
			'click' : 'togglePopover'

		render: ->
			@$el.html @template(@model.toJSON())
			@setupPopover()
			@

		setupPopover: ->
			@popover = new UserPopoverView model: @model
			@popover.bind 'popover:shown', (view) => 
				@trigger 'popover:shown', view
			, @
			@popover.triggerElement = @$el

		togglePopover: ->
			@popover.render() unless @popover.isRendered
			@popover.toggle()

		hidePopover: ->
			@popover.hide()

	class PopoverView extends Backbone.View
		triggerElement: null
		isDisplayed: false
		template: ''
		title: ''
		placement: 'left'
		isRendered: false
		triggerType: 'manual'

		initialize: (options) ->

		getModel: ->
			@model

		render: ->
			model = @getModel()
			@$el.html @template(model)
			html = @$el
			content = 
				toString: -> 
					replace: -> html
			$(@triggerElement).popover
				trigger: @triggerType
				title: => @title
				content: => content
				html: true
				placement: @placement
			@isRendered = true
			@

		toggle: ->
			if @isDisplayed then @hide() else @show()

		show: ->
			@trigger 'popover:shown', @
			$(@triggerElement).popover 'show'
			@isDisplayed = true
			@delegateEvents()

		hide: ->
			$(@triggerElement).popover 'hide'
			@isDisplayed = false	

	class UserPopoverView extends PopoverView
		template: Handlebars.compile $('#user_popover_template').html() ? ''

		initialize: ->
			@title = @model.get 'name'

		getModel: ->
			obj = @model.toJSON()
			obj.formattedLogin = app.util.formatDate(new Date obj.lastLogin)
			obj

		events: 
			'submit form' : 'updateUser'

		updateUser: (ev) ->
			ev.preventDefault()
			obj = app.util.parseForm @$('form')
			@model.save obj
			@hide()



	@app = window.app ? {}
	@app.LoginView = LoginView
	@app.UserGridView = UserGridView
	@app.ChatMasterView = ChatMasterView