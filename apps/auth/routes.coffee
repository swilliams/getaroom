routes = (app) ->

	_addUser = (username) ->
		app.settings.userCount += 1
		user = { id: app.settings.userCount, name: username }
		app.settings.userList.push user
		console.log app.settings.userList
		user

	app.get '/login', (req, res) ->
		res.render "#{__dirname}/views/login", 
			title: 'Login'
			session: req.session

	app.post '/sessions', (req, res) ->
		req.session.currentUser = req.body.user
		if socketIO = app.settings.socketIO
			user = _addUser req.session.currentUser
			socketIO.sockets.emit "user:loggedIn", user
		req.flash 'info', "You are now #{req.session.currentUser}"
		res.redirect '/chat'
		return

	app.post '/logout', (req, res) ->
		userId = req.body.id
		if socketIO = app.settings.socketIO
			socketIO.sockets.emit "user:loggedOut", { id: userId }	
		req.session.regenerate (err) ->
			req.flash 'info', 'You have been logged out'
			res.redirect '/login'

module.exports = routes