---
---
screens = {{ site.data.screens | jsonify }}
timedRefresh = (timeoutPeriod) ->
	id = Math.floor Math.random() * screens.length
	screen = screens[id]
	document.querySelector('.mdber').innerHTML = "{{ site.time }}"
	document.querySelector('#upper').innerHTML = screen.name.toUpperCase() + " #{id} / " + screens.length
	document.querySelector('.code').innerHTML = screen.code.split('').join('&nbsp;&nbsp;')
	document.querySelector('#lower').innerHTML = "BUILD_REVISION {{ site.github.build_revision }}" +
		"<br>RELEASE {{ site.github.releases | first |inspect }}"
	document.body.style.background = screen.color
	setTimeout timedRefresh, 10000

timedRefresh 10000
