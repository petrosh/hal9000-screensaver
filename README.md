# hal9000-screensaver

Screensaver with practices updated, better vertical.  
Installed on OSX via [liquidx/webviewscreensaver](https://github.com/liquidx/webviewscreensaver).

[![screenshot](/images/screenshot.png)](https:/petrosh.github.io/hal9000-screensaver)

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

Practices url too.

```yml
practices_url: https://ashtanga.github.io/practice.json
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
```
