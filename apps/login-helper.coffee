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

		# check for session
		# check for matching session id in cookie
		# check for ip
