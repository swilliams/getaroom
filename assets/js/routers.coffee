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
				@userView = new app.UserGridView collection: app.Users
				@userView.render()


	@app = window.app ? {}
	@app.router = new AppRouter
