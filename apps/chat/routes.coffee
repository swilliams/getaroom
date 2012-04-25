routes = (app) ->

	app.get '/chat', (req, res) ->
		# get the list of users
		res.render "#{__dirname}/views/main",
			title: 'OMG Chat!'
			session: req.session
			users: [req.session.currentUser]

	app.post '/chat', (req, res) ->
		text = req.body.content
		if socketIO = app.settings.socketIO
			socketIO.sockets.emit "msg:received", { content: text }
		res.send text



module.exports = routes