User = require "../models/user"

module.exports = (app) ->
	checkForSession = (req) ->
		req.session.currentUser

	checkForCookie = (req) ->
		req.session.id? and req.session.id == req.cookies['sessionId']

	redirectToLogin = (req, res) ->
		req.flash 'error', 'Please Sign In First'
		res.redirect '/login'

	app.checkLogin = (req, res, next) ->
		unless checkForSession req then redirectToLogin req, res
		unless checkForCookie req then redirectToLogin req, res
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
