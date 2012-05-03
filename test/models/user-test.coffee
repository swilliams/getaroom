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

	describe "#addIp", ->
		user = null
		before ->
			user = new User { name: 'swilliams', ips: [] }
			user.save = -> true

		it "adds the ip if doesnt already exist", ->
			ip = "192.168.1.1"
			user.addIp ip
			assert.equal ip, user.ips[0]

		it "doesn't add an ip if it already exists", ->
			ip = "192.168.1.1"
			user.ips = [ip]
			user.addIp ip
			assert.equal 1, user.ips.length

	describe "#toClientObject", ->
		user = null
		before ->
			user = new User { name: 'swilliams', active: 'adsfa' }

		it "only has the explicitly defined properties", ->
			clientObj = user.toClientObject()
			assert.isUndefined clientObj.active

	describe "#save", ->
		user = null
		before ->
			user = new User { id: 100, name: 'swilliams', active: true }
			user.save = -> true

		it "updates the name if for the user requesting the update", ->
			attrs = 
				name: 'honk'
				id: 100
			user.name = 'swilliams'
			user.update attrs, user
			assert.equal 'honk', user.name

		it "does not update the name if it is not the user requesting the update", ->
			attrs =
				name: 'honk'
				id: 200
			otherUser = new User { id: 120 }
			user.name = 'swilliams'
			user.update attrs, otherUser
			assert.equal 'swilliams', user.name

		it "updates the mute status if the asking user is a mod", ->
			attrs = isMuted: true
			mod = new User isMod: true
			user.update attrs, mod
			assert.equal true, user.isMuted

		it "doesn't mute the status if the asking user is not a mod", ->
			attrs = isMuted: true
			user.isMuted = false
			user.update attrs, user
			assert.equal false, user.isMuted

		it "doesn't mute other mods", ->
			user.isMuted = false
			attrs = isMuted: true
			user.isMod = true
			user.update attrs, user
			assert.equal false, user.isMuted

