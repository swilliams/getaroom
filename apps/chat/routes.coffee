routes = (app) ->
	app.all '/chat', (req, res, next) ->
		unless req.session.currentUser
			req.flash 'error', 'You need a name first'
			res.redirect '/login'
			return
		next()

	app.get '/chat', (req, res) ->
		# get the list of users
		res.render "#{__dirname}/views/main",
			title: 'OMG Chat!'
			session: req.session

	app.post '/chat', (req, res) ->
		text = req.body.content
		if socketIO = app.settings.socketIO
			socketIO.sockets.emit "msg:received", { user: req.session.currentUser, content: text }
		res.send text



module.exports = routes