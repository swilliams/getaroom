@app = window.app ? {}

jQuery ->
	Backbone.history.start(pushState: true)
