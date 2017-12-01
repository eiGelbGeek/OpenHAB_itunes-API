# OpenHAB integration of itunes-API
# https://github.com/maddox/itunes-api


## Example

```js
rule"MAIN Volume"
when
  //DIMMER ITEM
  Item Volume_Main received update
then
  executeCommandLine("/etc/openhab2/scripts/iTunes.sh " + "volume " + Volume_Main.state + " Computer")
end
```

```js
rule"Volume Office"
when
//DIMMER ITEM
  Item Volume_Office received update
then
  executeCommandLine("/etc/openhab2/scripts/iTunes.sh " + "volume "+ Volume_Office.state + " ID_FROM_AIRPLAY_DEVICE")
end
```

```js
rule"Volume Mute"
when
//SWITCH ITEM
  Item Mute_Item received update
then
  if (Mute_Item.state == ON){
    executeCommandLine("/etc/openhab2/scripts/iTunes.sh " + "mute " + "true")
  }
  else{
    executeCommandLine("/etc/openhab2/scripts/iTunes.sh " + "mute " + "false")
  }
end
```

```js
rule"Shuffle"
when
//NUMBER ITEM
  Item Shuffle_Item received update
then
  if (Shuffle_Item.state == 0) executeCommandLine("/etc/openhab2/scripts/iTunes.sh " + "shuffle " + "off")
  if (Shuffle_Item.state == 1) executeCommandLine("/etc/openhab2/scripts/iTunes.sh " + "shuffle " + "songs")
  if (Shuffle_Item.state == 2) executeCommandLine("/etc/openhab2/scripts/iTunes.sh " + "shuffle " + "albums")
  if (Shuffle_Item.state == 3) executeCommandLine("/etc/openhab2/scripts/iTunes.sh " + "shuffle " + "groupings")
end
```

```js
rule"Repeat"
when
//NUMBER ITEM
  Item Repeat_Item received update
then
  if (Repeat_Item.state == 0) executeCommandLine("/etc/openhab2/scripts/iTunes.sh " + "repeat "+ "off")
  if (Repeat_Item.state == 1) executeCommandLine("/etc/openhab2/scripts/iTunes.sh " + "repeat "+ "one")
  if (Repeat_Item.state == 2) executeCommandLine("/etc/openhab2/scripts/iTunes.sh " + "repeat "+ "all")
end
```

```js
rule"Play Playlist"
when
//NUMBER ITEM
  Item playlist_selection received update
then
  if (playlist_selection.state =! 0) executeCommandLine("/etc/openhab2/scripts/iTunes.sh " + "playlist " + playlist_selection.state)
  Thread::sleep(5000) // 5 Sekunden
  playlist_selection.sendCommand(0)
end
```
