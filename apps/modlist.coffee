User = require "../models/user"
_	 = require "underscore"

modlist = (app) ->
	_.each app.settings.defaultModList, (userId) ->
		User.getById userId, (err, user)->
			user.makeMod()


module.exports = modlist