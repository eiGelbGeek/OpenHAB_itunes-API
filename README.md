# OpenHAB integration of itunes-API
https://github.com/eiGelbGeek/itunes-api


## Sitemap

Cover -> Webview url="/static/iTunesCover.html" height=8

## Rule

```js
rule"Update Playlist from iTunes"
when
//NUMBER ITEM
  Item playlist_update received update
then
  executeCommandLine("sudo /etc/openhab2/scripts/oh_refresh_playlist_itunes-api.sh")
end
```

```js
rule"Play Playlist"
when
//NUMBER ITEM
  Item playlist_selection received update
then
  if (playlist_selection.state =! 0) executeCommandLine("/etc/openhab2/scripts/oh_itunes-api.sh " + "playlist " + playlist_selection.state)
  Thread::sleep(5000) // 5 Sekunden
  playlist_selection.sendCommand(0)
end
```

```js
rule"MAIN Volume"
when
  //DIMMER ITEM
  Item Volume_Main received update
then
  executeCommandLine("/etc/openhab2/scripts/oh_itunes-api.sh " + "volume " + Volume_Main.state + " Computer")
end
```

```js
rule"Volume Office"
when
//DIMMER ITEM
  Item Volume_Office received update
then
  executeCommandLine("/etc/openhab2/scripts/oh_itunes-api.sh " + "volume "+ Volume_Office.state + " ID_FROM_AIRPLAY_DEVICE")
end
```

```js
rule"Volume Mute"
when
//SWITCH ITEM
  Item Mute_Item received update
then
  if (Mute_Item.state == ON){
    executeCommandLine("/etc/openhab2/scripts/oh_itunes-api.sh " + "mute " + "true")
  }
  else{
    executeCommandLine("/etc/openhab2/scripts/oh_itunes-api.sh " + "mute " + "false")
  }
end
```

```js
rule"Shuffle"
when
//NUMBER ITEM
  Item Shuffle_Item received update
then
  if (Shuffle_Item.state == 0) executeCommandLine("/etc/openhab2/scripts/oh_itunes-api.sh " + "shuffle " + "off")
  if (Shuffle_Item.state == 1) executeCommandLine("/etc/openhab2/scripts/oh_itunes-api.sh " + "shuffle " + "songs")
  if (Shuffle_Item.state == 2) executeCommandLine("/etc/openhab2/scripts/oh_itunes-api.sh " + "shuffle " + "albums")
  if (Shuffle_Item.state == 3) executeCommandLine("/etc/openhab2/scripts/oh_itunes-api.sh " + "shuffle " + "groupings")
end
```

```js
rule"Repeat"
when
//NUMBER ITEM
  Item Repeat_Item received update
then
  if (Repeat_Item.state == 0) executeCommandLine("/etc/openhab2/scripts/oh_itunes-api.sh " + "repeat "+ "off")
  if (Repeat_Item.state == 1) executeCommandLine("/etc/openhab2/scripts/oh_itunes-api.sh " + "repeat "+ "one")
  if (Repeat_Item.state == 2) executeCommandLine("/etc/openhab2/scripts/oh_itunes-api.sh " + "repeat "+ "all")
end
```
