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
			console.log "logout"
			form = @getForm()
			form.submit()

	@app = window.app ? {}
	@app.LoginView = LoginView