_    = require 'underscore'
User = require '../../models/user'

routes = (app) ->

	_addUser = (req, username, next) ->
		User.getByUsername username, (err, user) ->
			if user is null
				console.log "new user"
				user = new User name: username
				user.save()
			console.log user
			req.session.currentUser = user
			next user

	app.get '/login', (req, res) ->
		res.render "#{__dirname}/views/login", 
			title: 'Login'
			session: req.session

	app.post '/sessions', (req, res) ->
		username = req.body.user
		_addUser req, username, (user) ->
			if socketIO = app.settings.socketIO
				socketIO.sockets.emit "user:loggedIn", user
			req.flash 'info', "You are now #{username}"
			res.redirect '/chat'
			return
		return

	app.post '/logout', (req, res) ->
		user = new User req.session.currentUser
		console.log user
		user.logout ->
			if socketIO = app.settings.socketIO
				socketIO.sockets.emit "user:loggedOut", { id: user.Id }	
			req.session.regenerate (err) ->
				req.flash 'info', 'You have been logged out'
				res.redirect '/login'

module.exports = routes