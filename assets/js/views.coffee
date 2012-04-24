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

		setupUserView: ->
			@userView = new UserGridView collection: app.Users
			@userView.render()

		setupChatEntry: ->
			@chatEntryView = new ChatEntryView
			@chatEntryView.render()

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
			newMessage = new app.Message text: @getText()
			newMessage.save()

	class UserGridView extends Backbone.View
		el: '#users'

		initialize: ->
			@collection.bind 'reset', @render, @

		render: ->
			@$el.empty()
			for user in @collection.models
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