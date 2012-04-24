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