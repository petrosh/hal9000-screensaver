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

cb = (r) ->
	console.log 'cb return: ', r
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
	console.log 'boxes: ', boxes
	for i in [14..0] by -1
		document.querySelector('.practices').innerHTML += if boxes[i] then divOn else divOff
	return

# XMLHttpRequest.coffee
loadJSON = (url) ->
  req = new XMLHttpRequest()
  req.addEventListener 'readystatechange', ->
    if req.readyState is 4 # ReadyState Complete
     successResultCodes = [200, 304]
     if req.status in successResultCodes
      cb JSON.parse req.responseText
      return
     else
      document.querySelector('.practices').innerHTML = 'error'
      return
  req.open 'GET', url, true
  req.send()
  return

loadJSON '{{ site.practices_url }}?date=' + new Date().getTime()
