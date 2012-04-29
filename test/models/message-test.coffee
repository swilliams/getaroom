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


