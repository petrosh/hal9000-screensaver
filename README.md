# hal9000-screensaver

Screensaver with practices updated, better vertical.  
Installed on OSX via [liquidx/webviewscreensaver](https://github.com/liquidx/webviewscreensaver).

[![screenshot_vertical](https://user-images.githubusercontent.com/4997583/39094937-7188e4cc-4638-11e8-9b9d-72a0cefd8bb0.png)](https://petrosh.github.io/hal9000-screensaver)

Screens are in [_data/screens.yml](_data/screens.yml).

```yml
-
  code: 'COM'
  name: 'Communications'
  color: '#825064'
```

Screen cycle and fade duration are in [_config.yml](_config.yml).

```yml
fade: 5s
cycle_ms: 20000
```

External feeds.

```yml
practices_url: https://ashtanga.github.io/practice.json
spacex_url: https://api.spacexdata.com/v2/launches/upcoming
```

Format expected

```json
[{
  "date": "2017-03-04"
}, {
  "date": "2017-03-06"
}, {
  "date": "2017-03-08"
}]

[{
  "cap_serial": null,
  "core_serial": "B1043",
  "details": null
}]
```
