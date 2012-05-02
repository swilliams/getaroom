@app = window.app ? {}

#= require 'vendor/jquery-1.7.2'
#= require 'vendor/underscore'
#= require 'vendor/bootstrap'
#= require 'vendor/backbone'
#= require 'vendor/handlebars-1.0.0.beta.6.js'
#= require 'models'
#= require 'collections'
#= require 'views'
#= require 'routers'
#= require 'util'

jQuery ->
	Backbone.history.start pushState: true
