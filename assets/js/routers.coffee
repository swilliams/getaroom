jQuery ->
	class AppRouter extends Backbone.Router
		routes: 
			'' : 'main'
			'chat' : 'chat'

		initialize: ->
			@loginView = new app.LoginView
			@loginView.render()

		main: ->

		chat: ->
			if $('#users')
				chatView = new app.ChatMasterView

	@app = window.app ? {}
	@app.router = new AppRouter
