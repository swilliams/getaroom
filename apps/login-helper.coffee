User = require "../models/user"

module.exports = (app) ->
	app.checkLogin = (req) ->
		# check for session
		# check for matching session id in cookie
		# check for ip
