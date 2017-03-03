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
	document.querySelector('#upper').innerHTML = screen.name.toUpperCase() + "<br>SCREEN: #{id}/" + screens.length
	document.querySelector('.subt').innerHTML = screen.code.split('').join('&nbsp;&nbsp;')
	document.querySelector('.code').innerHTML = ('0' + new Date().getHours()).slice(-2) + ":" + ('0' + new Date().getMinutes()).slice(-2)
	document.body.style.background = screen.color
	setTimeout timedRefresh, 20000

timedRefresh 20000
