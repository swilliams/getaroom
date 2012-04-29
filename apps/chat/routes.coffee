User = require "../../models/user"
Message = require "../../models/message"

routes = (app) ->
	app.all '/chat', (req, res, next) ->
		unless req.session.currentUser
			req.flash 'error', 'You need a name first'
			res.redirect '/login'
			return
		next()

	app.get '/chat', (req, res) ->
		User.active (err, users) ->
			res.render "#{__dirname}/views/main",
				title: 'OMG Chat!'
				session: req.session
				users: users

	app.post '/chat', (req, res) ->
		msg = new Message req.session.currentUser.id, content: req.body.content
		if socketIO = app.settings.socketIO
			socketIO.sockets.emit "msg:received", msg
		res.send ''


module.exports = routes