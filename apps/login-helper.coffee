User = require "../models/user"

module.exports = (app) ->
	checkForSession = (req) ->
		req.session.currentUser

	checkForCookie = (req) ->
		req.session.id? and req.session.id == req.cookies['connect.sid']

	redirectToLogin = (req, res) ->
		req.flash 'error', 'Please Sign In First'
		res.redirect '/login'

	updateCookie = (req, res) ->
		res.cookie 'sessionId', req.session.id, maxAge: 31536000000

	destroyCookie = (res) ->
		res.cookie 'sessionId', "", maxAge: 1

	app.checkLogin = (req, res, next) ->
		unless checkForSession req 
			redirectToLogin req, res
			return
		unless checkForCookie req 
			redirectToLogin req, res
			return
		clientIp = req.connection.remoteAddress
		User.getIdBySession req.session.id, (err, userId) ->
			if userId?
				User.getById userId, (err, user) ->
					if user.hasIp clientIp
						next()
					else
						redirectToLogin req, res
			else
				redirectToLogin req, res

	app.login = (req, res, twitterData, oauthAccesstoken, oauthAccesstokenSecret) ->
		username = twitterData.screen_name
		# find the user
		User.getByUsername username, (err, user) ->
			if user is null
				user = User.fromTwitter oauthAccesstoken, oauthAccesstokenSecret, twitterData
			updateCookie req, res
			user.login req.session.id, req.connection.remoteAddress,  ->
				req.session.currentUser = user
				if socketIO = app.settings.socketIO
					socketIO.sockets.emit "user:loggedIn", user.toClientObject()
				req.flash 'info', "You are now #{username}"
				res.redirect '/chat'

	app.logout = (req, res) ->
		destroyCookie res
		user = new User req.session.currentUser
		user.logout req.session.id, ->
			if socketIO = app.settings.socketIO
				socketIO.sockets.emit "user:loggedOut", user
			req.session.regenerate (err) ->
				req.flash 'info', 'You have been logged out'
				res.redirect '/login'




