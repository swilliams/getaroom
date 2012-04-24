jQuery ->
	class AppRouter extends Backbone.Router
		routes: 
			'' : 'main'

		initialize: ->
			@loginView = new app.LoginView
			@loginView.render()

		main: ->


	@app = window.app ? {}
	@app.router = new AppRouter
