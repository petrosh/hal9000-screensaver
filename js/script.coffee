---
---

if window.innerWidth > window.innerHeight
	divs = document.querySelectorAll('#top, #bottom')
	for e in divs
		e.style.display = 'none'

screens = {{ site.data.screens | jsonify }}
timedRefresh = (timeoutPeriod) ->
	id = Math.floor Math.random() * screens.length
	screen = screens[id]
	document.querySelector('#upper').innerHTML = screen.name.replace(/\s/g,'_').toUpperCase() +
		"<span class='right'>#{id}/" + screens.length + "</span>"
	month = ('0' + (new Date().getMonth() + 1)).slice -2
	day = ('0' + (new Date().getDate() + 1)).slice -2
	year = new Date().getFullYear()
	document.querySelector('.mdber').innerHTML = year + month + day  + '/' + new Date().getDay() + '/' + yearDay()
	document.querySelector('.subt').innerHTML = screen.code.split('').join('&nbsp;&nbsp;')
	document.querySelector('.code').innerHTML = ('0' + new Date().getHours()).slice(-2) + ":" + ('0' + new Date().getMinutes()).slice(-2)
	document.body.style.background = screen.color
	setTimeout timedRefresh timeoutPeriod, timeoutPeriod

# timedRefresh 20000
setTimeout ( ->
  timedRefresh 20000
), 2000

yearDay = ->
	now = new Date()
	start = new Date(now.getFullYear(), 0, 0)
	diff = now - start
	oneDay = 1000 * 60 * 60 * 24
	return ('0' + Math.floor(diff / oneDay)).slice(-3)
