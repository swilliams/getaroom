routes = (app) ->

	app.get '/login', (req, res) ->
		res.render "#{__dirname}/views/login", 
			title: 'Login'
			session: req.session

	app.post '/sessions', (req, res) ->
		req.session.currentUser = req.body.user
		req.flash 'info', "You are now #{req.session.currentUser}"
		res.redirect '/chat'
		return

	app.post '/logout', (req, res) ->
		req.session.regenerate (err) ->
			req.flash 'info', 'You have been logged out'
			res.redirect '/login'

module.exports = routes