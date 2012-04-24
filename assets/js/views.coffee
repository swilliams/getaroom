jQuery ->
	class LoginView extends Backbone.View
		el: '#login_container'
		initialize: ->

		events: 
			'click #logout' : 'logout'

		render: ->
			@

		logout: (ev) ->
			ev.preventDefault()
			console.log "logout"

	@app = window.app ? {}
	@app.LoginView = LoginView