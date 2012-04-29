require "../_helper"
assert = require 'assert'
Message = require "../../models/message.coffee"

describe "Message", ->

	describe "ctor", ->
		message = null
		before ->
			message = new Message 100

		it "sets the content by default", ->
			assert.equal '', message.content

