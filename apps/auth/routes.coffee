_    = require 'underscore'
User = require '../../models/user'

routes = (app) ->

	_addUser = (req, username, next) ->
		User.getByUsername username, (resp, user) ->
			console.log user
			if user is null
				console.log "null"
				user = new User name: username
				user.save()
			req.session.currentUser = user
			next user

	_removeUser = (user) ->
		# log user out

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
		userId = req.body.id
		if socketIO = app.settings.socketIO
			socketIO.sockets.emit "user:loggedOut", { id: userId }	
			_removeUser userId
		req.session.regenerate (err) ->
			req.flash 'info', 'You have been logged out'
			res.redirect '/login'

module.exports = routes