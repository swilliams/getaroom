require "../_helper"
assert = require 'assert'
Message = require "../../models/message.coffee"

describe "Message", ->

	describe "ctor", ->
		message = null
		before ->
			message = new Message

		it "sets the content by default", ->
			assert.equal '', message.content

