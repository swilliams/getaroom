require "../_helper"
assert = require 'assert'
User   = require "../../models/user.coffee"

describe "User", ->
	describe "ctor", ->
		user = null
		before ->
			user = new User { name: 'swilliams' }

		it "sets the name", ->
			assert.equal user.name, "swilliams"

	describe "#generateId", ->
		user = null
		before ->
			user = new User { name: 'swilliams', id: null }

		it "creates an id on the model", ->
			user.generateId()
			assert.equal user.id, 'swilliams'

		it "converts spaces to dashed", ->
			user.id = null
			user.name = "test one"
			user.generateId()
			assert.equal user.id, 'test-one'

	describe "#setDefaults", ->
		user = null
		before ->
			user = new User { name: 'swilliams' }

		it "sets the default active status", ->
			assert.equal true, user.active?
			assert.equal true, user.active