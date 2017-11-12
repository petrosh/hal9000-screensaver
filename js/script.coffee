---
---

if window.innerWidth > window.innerHeight
	for e in document.querySelectorAll('#top, #bottom')
		e.style.display = 'none'

yearDay = ->
	diff = new Date() - new Date(new Date().getFullYear(), 0, 0)
	oneDay = 1000 * 60 * 60 * 24
	return ('0' + Math.floor(diff / oneDay)).slice(-3)

screens = {{ site.data.screens | jsonify }}

timedRefresh = (timeoutPeriod) ->
	id = Math.floor Math.random() * screens.length
	screen = screens[id]
	screenName = screen.name.replace(/\s/g, '_')
	document.querySelector('#upper').innerHTML = screenName.toUpperCase() + "<span class='right'>#{id}/" + screens.length + "</span>"
	month = ('0' + (new Date().getMonth() + 1)).slice -2
	day = ('0' + new Date().getDate()).slice -2
	year = new Date().getFullYear()
	document.querySelector('.mdber').innerHTML = year + month + day  + '/' + new Date().getDay() + '/' + yearDay()
	document.querySelector('.subt').innerHTML = screen.code.split('').join('&nbsp;&nbsp;')
	document.querySelector('.code').innerHTML = ('0' + new Date().getHours()).slice(-2) + ":" + ('0' + new Date().getMinutes()).slice(-2)
	document.body.style.background = screen.color
	setTimeout timedRefresh , {{ site.cycle_ms }}

# timedRefresh 20000
setTimeout ( ->
	timedRefresh()
), 500

new_date = new Date().getTime()
unix_hour = 60 * 60
unix_day = unix_hour * 24
unix_month = unix_day * 30

cb_practice = (r) ->
	boxes = []
	divOn = '<div class="on"></div>'
	divOff = '<div class="off"></div>'
	today = new Date()
	milliseconds = 1000*60*60*24
	for p in r
		practice = new Date(p.date)
		dayNumber = new Date(p.date).getDay()
		diff = Math.floor (today-practice)/ milliseconds
		if diff < 16 then boxes[diff] = 1
	for i in [14..0] by -1
		document.querySelector('.practices').innerHTML += if boxes[i] then divOn else divOff
	return

cb_spacex = (r) ->
	table = document.createElement 'table'
	for p in r
		t_minus = p.launch_date_unix - (new_date / 1000)
		switch
			when (t_minus < 172800) # 2 days
				t_message = (t_minus / unix_hour).toFixed(1) + "h"
			when (t_minus > unix_month)
				t_message = (t_minus / unix_month).toFixed(1) + "m"
			else
				t_message = (t_minus / unix_day).toFixed(1) + "d"
		stream = [
			p.payloads[0].payload_id
			p.payloads[0].payload_type
			p.payloads[0].orbit
			p.launch_site.site_name.replace /(?=\D)\s(?=\d)/g, '-'
			p.landing_vehicle || 'expandible'
			"-" + t_message
			('0' + new Date(p.launch_date_utc).getHours()).slice(-2) +
			":" +
			('0' + new Date(p.launch_date_utc).getMinutes()).slice(-2)
			p.core_serial
		]
		row = document.createElement 'tr'
		for s in stream
			cell = document.createElement 'td'
			cell.innerHTML = s
			row.appendChild cell
		if p.reused
			# console.log loadJSON "{{ site.spacex_cores_url }}#{p.core_serial}?date=#{new_date}", cb_reflow
			fetch "{{ site.spacex_cores_url }}#{p.core_serial}?date=#{new_date}"
				.then (response) -> response.json()
				.then (json) ->
					gap = ((p.launch_date_unix - json[0].launch_date_unix) / unix_month).toFixed(1) + "m"
					row.innerHTML += "<td>#{gap} #{json[0].payloads[0].orbit} #{json[0].landing_vehicle}</td>"
				.then table.appendChild row
		else table.appendChild row
		console.log p
	document.querySelector('#content').appendChild table
	return

# XMLHttpRequest.coffee
loadJSON = (url, cb) ->
	req = new XMLHttpRequest()
	req.addEventListener 'readystatechange', ->
		# console.log 'req.readyState: ', req.readyState
		if req.readyState is 4 # ReadyState Complete
			successResultCodes = [200, 304]
			# console.log 'req.status: ', req.status
			# console.log 'req.statusText: ', req.statusText
			if req.status in successResultCodes
				cb JSON.parse req.responseText
			else
				document.querySelector('.practices').innerHTML = 'error'
	# console.log 'req: ', req
	req.open 'GET', url, true
	req.send()
	return

loadJSON "{{ site.practices_url }}?date=#{new_date}", cb_practice
loadJSON "{{ site.spacex_url }}?date=#{new_date}", cb_spacex