@app = window.app ? {}

@app.util = 

	formatDate: (d) ->
		"#{d.getHours()}:#{d.getMinutes()}:#{d.getSeconds()}"
