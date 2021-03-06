---
---

# if window.innerWidth > window.innerHeight
# 	for e in document.querySelectorAll('#top, #bottom')
# 		e.style.display = 'none'

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
	# Sort by launch_date_unix
	r.sort (obj1, obj2) => obj1.launch_date_unix - obj2.launch_date_unix
	# for item in temporals
	# 	console.log item.flight_number, item.launch_date_unix
	table = document.createElement 'table'
	tfoot = document.createElement 'tfoot'
	tbody = document.createElement 'tbody'
	tfoot.innerHTML = "<tr>
		<td>id<span>customer</span></td>
		<td>S2 type [serial] mass_kg to orbit<span>#n gap id orbit flight_time</span></td>
		<td>S1 name type to vehicle [serial]<span>#n gap id orbit vehicle</span></td>
		<td>site_name<span>#n date_local</span></td>
		<td>T minus<span>unit</span></td>
		<td>launch_time<span>time_local</span></td>
	</tr>"
	# if window.innerWidth > window.innerHeight then table.style.display = 'none'
	if window.innerWidth > window.innerHeight then document.querySelector('#content').classList = 'short'
	for p in r
		if p.launch_date_unix
			# Compare dates
			timed_utc = new Date(p.launch_date_utc).getTime().toString()
			timed_local = new Date(p.launch_date_local).getTime().toString()
			coherent = if p.launch_date_unix.toString() != timed_utc.slice(0,10) || p.launch_date_unix.toString() != timed_local.slice(0,10) then "*" else ""
			core_reused = if p.reused then '*' else ''
			# cap_reused = if p.reused.capsule then '*' else ''
			t_minus = p.launch_date_unix - (new_date / 1000)
			t_positive = if t_minus > 0 then true else false
			timezone = -1 * new Date().getTimezoneOffset() / 60
			tz = if timezone > 0 then "+#{('0' + timezone).slice(-2)}" else "#{('0' + timezone).slice(-2)}"
			offset = p.launch_date_local.substr(-6,3)
			launch_time = ('0' + new Date(p.launch_date_utc).getHours()).slice(-2) +
				":" + ('0' + new Date(p.launch_date_utc).getMinutes()).slice(-2)
			launch_time_local = ('0' + new Date(p.launch_date_local.substr(0,19)).getHours()).slice(-2) +
				":" + ('0' + new Date(p.launch_date_local.substr(0,19)).getMinutes()).slice(-2)
			switch
				when ((t_positive and t_minus < 172800) or (!t_positive and t_minus > -172800)) # 2 days
					t_message = (t_minus / unix_hour).toPrecision(2) * (-1)
					t_units = "hours"
				when (t_minus > unix_month)
					t_message = (t_minus / unix_month).toPrecision(2) * (-1)
					t_units = "months"
				else
					t_message = (t_minus / unix_day).toPrecision(2) * (-1)
					t_units = "days"
			row = document.createElement 'tr'
			row.setAttribute 'data-launch', "#{p.launch_date_unix}"
			if p.tbd then row.classList = 'tbd'
			body = ''
			#
			# CELL 1
			#
			# :PAYLOAD_ID
			# :CUSTOMERS[0]
			body += "<td>#{(p.rocket.second_stage.payloads.map (p) -> p.payload_id).join ' / '}<span>#{(p.rocket.second_stage.payloads.map (p) -> p.customers[0]).join ' / '}</span></td>"
			#
			# CELL 2
			#
			# :PAYLOAD_TYPE
			body += "<td>#{p.rocket.second_stage.payloads[0].payload_type}"
			# [:CAP_SERIAL]
			if p.rocket.second_stage.payloads[0].cap_serial
				body += " [<small>#{p.rocket.second_stage.payloads[0].cap_serial}</small>]"
			# [Weigth]
			kg = (p.rocket.second_stage.payloads.map (p) -> p.payload_mass_kg).join 'kg + '
			body += " <small>#{if kg then kg else '? '}kg</small> "
			# to :ORBIT
			# :CAP_SERIAL
			body += " to #{p.rocket.second_stage.payloads[0].orbit}<span id='#{p.rocket.second_stage.payloads[0].cap_serial}'></span>"
			body += "</td>"
			#
			# CELL 3
			#
			# :ROCKET_NAME :ROCKET_TYPE [:CORE_SERIAL] to :LANDING_VEHICLE
			# CORE_SERIAL
			body += "<td>#{p.rocket.rocket_name} #{p.rocket.rocket_type}#{if p.rocket.first_stage.cores[0].landing_vehicle then " to #{p.rocket.first_stage.cores[0].landing_vehicle} " else ' EXP '}"
			body += "[<small>"
			for c, i in p.rocket.first_stage.cores
				if i!=0 then body += ' '
				body += "#{c.core_serial or 'TBD'}"
			body += "</small>]"
			for c in p.rocket.first_stage.cores
				span_id = if c.core_serial then c.core_serial.split(".")[0] else 'tbd'
				body += "<span id='#{span_id}'></span>"
				# body += "<span id='#{c.core_serial.split}'></span>"
			body += "</td>"
			#
			# CELL 4
			#
			# :LAUNCH_SITE_NAME
			# #:FLIGHT_NUMBER :LOCAL_DATE
			body += "<td>#{p.launch_site.site_name.replace /(?=\D)\s(?=\d)/g, '-'}<span>##{p.flight_number} #{p.launch_date_local.substr(0,10)}</span></td>"
			#
			# CELL 5
			#
			# :T_MESSAGE
			# :LAUNCH_TIME
			body += "<td>T#{if t_message > 0 then "+#{t_message}" else t_message}<span>#{t_units.toUpperCase()}</span></td>"
			#
			# CELL 6
			#
			body += "<td>#{launch_time}#{tz}<span>#{launch_time_local}#{offset}#{coherent}</span></td>"
			if (p.rocket.first_stage.cores[0].reused and p.rocket.first_stage.cores[0].core_serial) or p.rocket.first_stage.cores[0].flight > 1 then core_reflown.push p.rocket.first_stage.cores[0].core_serial
			if p.rocket.first_stage.cores.length > 1
				if p.rocket.first_stage.cores[1].reused then core_reflown.push p.rocket.first_stage.cores[1].core_serial
				if p.rocket.first_stage.cores[2].reused then core_reflown.push p.rocket.first_stage.cores[2].core_serial
			# Check capsule reused
			if p.rocket.second_stage.payloads[0].reused && p.rocket.second_stage.payloads[0].cap_serial
				cap_reflown.push p.rocket.second_stage.payloads[0].cap_serial
				console.log p.rocket.second_stage.payloads[0]
			row.innerHTML = body
			tbody.appendChild row
	table.appendChild tbody
	table.appendChild tfoot
	document.querySelector('#lower').appendChild table
	for core_id in core_reflown
		# loadJSON "{{ site.spacex_api }}?core_serial=#{core_id}&date=#{new_date}", cb_reflow
		loadJSON "{{ site.spacex_api }}?core_serial=#{core_id.split(".")[0]}&date=#{new_date}", cb_reflow
	for cap_id in cap_reflown
		loadJSON "{{ site.spacex_api }}?cap_serial=#{cap_id}&date=#{new_date}", cb_reflow
	return

cb_reflow = (r, u) ->
	for exvoli in [0..(r.length - 2)]
	  # body...
		launch = r[exvoli]
		if launch
			if /core_serial/.test u then id = launch.rocket.first_stage.cores[0].core_serial
			if /cap_serial/.test u then id = launch.rocket.second_stage.payloads[0].cap_serial
			ele = document.getElementById id
			if ele.innerHTML.length > 0
				ele.innerHTML += '<br>'
			gap = ((ele.parentNode.parentNode.getAttribute('data-launch') - launch.launch_date_unix) / unix_month).toPrecision(2) + " Months"
			if /core_serial/.test u then ele.innerHTML += "##{launch.flight_number} #{gap} #{launch.rocket.second_stage.payloads[0].payload_id} #{launch.rocket.second_stage.payloads[0].orbit} #{launch.rocket.first_stage.cores[0].landing_vehicle}"
			if /cap_serial/.test u then ele.innerHTML += "##{launch.flight_number} #{gap} #{launch.rocket.second_stage.payloads[0].payload_id} #{launch.rocket.second_stage.payloads[0].orbit} #{(launch.rocket.second_stage.payloads[0].flight_time_sec / unix_day).toPrecision(2)} Days"
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

loadJSON "{{ site.practices_url }}", cb_practice
loadJSON "{{ site.spacex_api }}upcoming?date=#{new_date}", cb_spacex
