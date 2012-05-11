_    = require 'underscore'
User = require '../../models/user'

routes = (app) ->

	_addUser = (req, username, next) ->
		User.getByUsername username, (err, user) ->
			if user is null
				user = new User name: username
			user.login ->
				req.session.currentUser = user#.toClientObject()
				next user

	app.get '/login', (req, res) ->
		res.render "#{__dirname}/views/login", 
			title: 'Login'
			session: req.session

	app.post '/sessions', (req, res) ->
		username = req.body.user
		_addUser req, username, (user) ->
			ip = req.connection.remoteAddress
			user.addIp ip
			if socketIO = app.settings.socketIO
				socketIO.sockets.emit "user:loggedIn", user.toClientObject()
			req.flash 'info', "You are now #{username}"
			res.redirect '/chat'
			return
		return

	app.post '/logout', (req, res) ->
		app.logout req, res
		# user = new User req.session.currentUser
		# user.logout req.session.id, ->
		# 	if socketIO = app.settings.socketIO
		# 		socketIO.sockets.emit "user:loggedOut", user
		# 	req.session.regenerate (err) ->
		# 		req.flash 'info', 'You have been logged out'
		# 		res.redirect '/login'

	app.get '/login/connect', (req, res) ->
		app.consumer().getOAuthRequestToken (err, oauthToken, oauthTokenSecret, results) ->
			if err
				res.send "error getting oauth req token: #{err}", 500
			else
				req.session.oauthRequestToken = oauthToken
				req.session.oauthRequestTokenSecret = oauthTokenSecret
				res.redirect "https://twitter.com/oauth/authorize?oauth_token=#{req.session.oauthRequestToken}"

	app.get '/login/callback', (req, res) ->
		app.consumer().getOAuthAccessToken req.session.oauthRequestToken, req.session.oauthRequestTokenSecret, req.query.oauth_verifier, (err, oauthAccessToken, oauthAccessTokenSecret, results) ->
			if err
				res.send "error getting oauth access token: #{err}", 500
			else
				req.session.oauthAccessToken = oauthAccessToken
				req.session.oauthAccessTokenSecret = oauthAccessTokenSecret
				app.consumer().get "http://twitter.com/account/verify_credentials.json", req.session.oauthAccessToken, req.session.oauthAccessTokenSecret, (err, data, resp) ->
					if err
						res.send "error getting screen name: #{err}", 500
					else
						data = JSON.parse data
						app.login req, res, data, oauthAccessToken, oauthAccessTokenSecret


module.exports = routes