---
---
screens = {{ site.data.screens | jsonify }}
timedRefresh = (timeoutPeriod) ->
	id = Math.floor Math.random() * screens.length
	screen = screens[id]
	document.querySelector('.mdber').innerHTML = "{{ site.time }}"
	document.querySelector('#upper').innerHTML = screen.name.toUpperCase()
	document.querySelector('.code').innerHTML = screen.code.split('').join('&nbsp;&nbsp;')
	document.querySelector('#lower').innerHTML = "#{id} / " + screens.length
	document.body.style.background = screen.color
	setTimeout "location.reload(true);",timeoutPeriod

timedRefresh(10000)
