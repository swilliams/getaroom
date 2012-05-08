require 'oauth'

module.exports = (app) ->
	unless app.settings.twitterConsumerKey
		app.set 'twitterConsumerKey', ""
		app.set 'twitterConsumerSecret', ""
