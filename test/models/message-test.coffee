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

	describe "#save", ->
		msg = null
		before (done) ->
			msg = new Message 100, content: "this is content"
			msg.save ->
				done()

		it "returns a message object", ->
			assert.instanceOf msg, Message

		it "sets an id", ->
			assert.notNull msg.id


	describe "#validate", ->
		msg = null
		before ->
			msg = new Message 100

		it "returns false for a message that is longer than 280 characters", ->
			msg.content = 
			'''
			Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu 
			'''
			result = msg.validate()
			assert.ok result.length > 0

		it "is valid for a message that is shorter than 280 chars", -> 
			msg.content = "short"
			result = msg.validate()
			assert.isNull result