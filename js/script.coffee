---
---
screens = {{ site.data.screens | jsonify }}
timedRefresh = (timeoutPeriod) ->
	id = Math.floor Math.random() * screens.length
	screen = screens[id]
	document.querySelector('.mdber').innerHTML = "{{ site.time }}"
	document.querySelector('#upper').innerHTML = screen.name.toUpperCase() + " - #{id}/" + screens.length
	document.querySelector('.code').innerHTML = screen.code.split('').join('&nbsp;&nbsp;')
	document.querySelector('#lower').innerHTML = "{% include releases.html %}" +
		"<br>BUILD_REVISION: {{ site.github.build_revision }}"
	document.body.style.background = screen.color
	setTimeout timedRefresh, 20000

timedRefresh 20000
