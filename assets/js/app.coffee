@app = window.app ? {}

#= require 'vendor/jquery-1.7.2'
#= require 'vendor/underscore'
#= require 'vendor/bootstrap'
#= require 'vendor/backbone'
#= require 'models'
#= require 'collections'
#= require 'views'
#= require 'routers'

jQuery ->
	Backbone.history.start pushState: true
