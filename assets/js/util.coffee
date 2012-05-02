@app = window.app ? {}

@app.util = 

	formatDate: (d) ->
		"#{d.getHours()}:#{d.getMinutes()}:#{d.getSeconds()}"

	parseForm: (form) ->
		obj = {}
		$(form).find('input, select, textarea').each (i, elem) ->
			e = $(elem)
			name = e.attr('name')
			if name?
				val = if e.is('[type=checkbox]') then e.is(':checked') else e.val()
				obj[name] = val
		obj
