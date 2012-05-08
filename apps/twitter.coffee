oauth = require 'oauth'

module.exports = (app) ->
	twitterConsumerKey = "LP6i7Eb5c5IgxvLmeK6iQ"
	twitterConsumerSecret = "Ae871snIrHR8WJJ4yKbdaHKMGJT9EG44izPGTUYkj8"

	app.consumer = ->
		new oauth.OAuth "https://twitter.com/oauth/request_token", 
			"https://twitter.com/oauth/access_token", 
			twitterConsumerKey, twitterConsumerSecret,
			"1.0A", "http://localhost:3000/login/callback",
			"HMAC-SHA1"
