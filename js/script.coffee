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

core_reflown = []
cap_reflown = []

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
		core_reused = if p.reused then '*' else ''
		cap_reused = if p.reuse.capsule then '*' else ''
		t_minus = p.launch_date_unix - (new_date / 1000)
		launch_time = ('0' + new Date(p.launch_date_utc).getHours()).slice(-2) +
			":" + ('0' + new Date(p.launch_date_utc).getMinutes()).slice(-2)
		switch
			when (t_minus < 172800) # 2 days
				t_message = (t_minus / unix_hour).toPrecision(2) + "h"
			when (t_minus > unix_month)
				t_message = (t_minus / unix_month).toPrecision(2) + "m"
			else
				t_message = (t_minus / unix_day).toPrecision(2) + "d"
		row = document.createElement 'tr'
		row.setAttribute 'data-launch', "#{p.launch_date_unix}"
		row.innerHTML += "<td>#{p.payloads[0].payload_id}</td>"
		row.innerHTML += "<td>#{p.payloads[0].payload_type}</td>" # cap_reused +
		row.innerHTML += "<td id='#{p.cap_serial}'></td>"
		row.innerHTML += "<td>#{p.core_serial}</td>" # core_reused +
		row.innerHTML += "<td id='#{p.core_serial}'></td>"
		row.innerHTML += "<td>[<small>#{p.payloads[0].orbit}</small>]</td>"
		row.innerHTML += "<td>#{p.launch_site.site_name.replace /(?=\D)\s(?=\d)/g, '-'}</td>"
		row.innerHTML += "<td>#{p.landing_vehicle || 'expandible'}</td>"
		row.innerHTML += "<td>#{"-" + t_message}</td>"
		row.innerHTML += "<td>#{launch_time}</td>"
		if p.reuse.core then core_reflown.push p.core_serial
		if p.reuse.capsule then cap_reflown.push p.cap_serial
		table.appendChild row
	document.querySelector('#content').appendChild table
	for core_id in core_reflown
		loadJSON "{{ site.spacex_id_url }}cores/#{core_id}?date=#{new_date}", cb_reflow
	for cap_id in cap_reflown
		loadJSON "{{ site.spacex_id_url }}caps/#{cap_id}?date=#{new_date}", cb_reflow
	return

cb_reflow = (r, u) ->
	launch = r[0]
	if /core/.test u then id = launch.core_serial
	if /caps/.test u then id = launch.cap_serial
	ele = document.getElementById id
	gap = ((ele.parentNode.getAttribute('data-launch') - launch.launch_date_unix) / unix_month).toPrecision(2) + "m"
	if /core/.test u then ele.innerHTML = "#{gap} #{launch.payloads[0].orbit} #{launch.landing_vehicle}"
	if /caps/.test u then ele.innerHTML = "#{gap} #{launch.payloads[0].orbit} #{(launch.payloads[0].flight_time_sec / unix_day).toPrecision(2)}d"
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
				cb(JSON.parse(req.responseText), url)
			else
				document.querySelector('.practices').innerHTML = 'error'
	# console.log 'req: ', req
	req.open 'GET', url, true
	req.send()
	return

loadJSON "{{ site.practices_url }}?date=#{new_date}", cb_practice
loadJSON "{{ site.spacex_url }}?date=#{new_date}", cb_spacex