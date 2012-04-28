_ = require 'underscore'

routes = (app) ->

	_addUser = (username) ->
		app.settings.userCount += 1
		user = { id: app.settings.userCount, name: username }
		app.settings.userList.push user
		console.log app.settings.userList
		user

	_removeUser = (userId) ->
		userList = _.reject app.settings.userList, (u) -> u.id == userId
		app.set 'userList', userList

	app.get '/login', (req, res) ->
		res.render "#{__dirname}/views/login", 
			title: 'Login'
			session: req.session

	app.post '/sessions', (req, res) ->
		req.session.currentUser = req.body.user
		user = _addUser req.session.currentUser
		if socketIO = app.settings.socketIO
			socketIO.sockets.emit "user:loggedIn", user
		req.flash 'info', "You are now #{req.session.currentUser}"
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