assert = require 'assert'
request = require 'request'
app = require '../../server'

describe "auth", ->
	describe "GET /login", ->
		_body = null

		before (done) ->
			options = 
				uri: "http://localhost:#{app.settings.port}/login"
			request options, (err, res, body) ->
				_body = body
				done()

		it "has title", ->
			assert.hasTag _body, '//head/title', 'Login'
