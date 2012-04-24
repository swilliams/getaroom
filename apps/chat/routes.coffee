routes = (app) ->

	app.get '/chat', (req, res) ->
		res.render "#{__dirname}/views/main",
			title: 'OMG Chat!'
			session: req.session

module.exports = routes