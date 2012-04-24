assert = require 'assert'
request = require 'request'
app = require '../../server'

describe "auth", ->
	describe "GET /login", ->
		_body = null

		before (done) ->
			options = 
				uri: 'http://localhost:3000/login'
			request options, (err, res, body) ->
				_body = body
				done()

		it "has user field", ->
			assert.ok /user/.test(_body)
