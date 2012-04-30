User 	= require "../../models/user"
Message = require "../../models/message"
_ 		= require "underscore"

routes = (app) ->
	app.all '/chat', (req, res, next) ->
		unless req.session.currentUser
			req.flash 'error', 'You need a name first'
			res.redirect '/login'
			return
		next()

	app.get '/chat', (req, res) ->
		currentUser = new User req.session.currentUser
		User.active (err, users) ->
			clientObjects = _.map users, (u) -> u.toClientObject()
			res.render "#{__dirname}/views/main",
				title: 'OMG Chat!'
				session: req.session
				users: clientObjects
				currentUser: currentUser.toClientObject()

	app.post '/chat', (req, res) ->
		msg = new Message req.session.currentUser.id, content: req.body.content
		if socketIO = app.settings.socketIO
			socketIO.sockets.emit "msg:received", msg
		res.send ''


module.exports = routes