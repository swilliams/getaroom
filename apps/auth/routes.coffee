_    = require 'underscore'
User = require '../../models/user'

routes = (app) ->

	app.get '/login', (req, res) ->
		res.render "#{__dirname}/views/login", 
			title: 'Login'
			session: req.session

	app.post '/logout', (req, res) ->
		app.logout req, res

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