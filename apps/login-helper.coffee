User = require "../models/user"

module.exports = (app) ->
	checkForSession = (req) ->
		console.log "checkForSession"
		req.session.currentUser

	checkForCookie = (req) ->
		console.log "cookie check"
		req.session.id? and req.session.id == req.cookies['sessionId']

	redirectToLogin = (req, res) ->
		console.log "Redirect"
		req.flash 'error', 'Please Sign In First'
		res.redirect '/login'

	updateCookie = (req, res) ->
		res.cookie 'sessionId', req.session.id, maxAge: 31536000000

	app.checkLogin = (req, res, next) ->
		console.log "checkLogin"
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
						next user
					else
						redirectToLogin req, res

	app.login = (req, res, twitterData, oauthAccesstoken, oauthAccesstokenSecret) ->
		console.log "logging in"
		username = twitterData.screen_name
		# find the user
		User.getByUsername username, (err, user) ->
			if user is null
				console.log "new user"
				user = User.fromTwitter oauthAccesstoken, oauthAccesstokenSecret, twitterData
			user.login req.connection.remoteAddress,  ->
				console.log "logged in"
				req.session.currentUser = user
				if socketIO = app.settings.socketIO
					socketIO.sockets.emit "user:loggedIn", user.toClientObject()
				req.flash 'info', "You are now #{username}"
				res.redirect '/chat'



