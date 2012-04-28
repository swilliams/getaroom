_    = require 'underscore'
User = require '../../models/user'

routes = (app) ->

	_addUser = (username) ->
		user = User.getByUsername username
		if user is null
			user = new User name: username
			user.save()
		user

	_removeUser = (userId) ->
		userList = _.reject app.settings.userList, (u) -> u.id == userId
		app.set 'userList', userList

	app.get '/login', (req, res) ->
		res.render "#{__dirname}/views/login", 
			title: 'Login'
			session: req.session

	app.post '/sessions', (req, res) ->
		username = req.body.user
		user = _addUser username
		req.session.currentUser = user
		if socketIO = app.settings.socketIO
			socketIO.sockets.emit "user:loggedIn", user
		req.flash 'info', "You are now #{username}"
		res.redirect '/chat'
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