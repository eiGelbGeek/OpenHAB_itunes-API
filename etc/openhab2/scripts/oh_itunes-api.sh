#!/bin/bash

################################################################################
#BashScript zur Steuerung der iTunes-Api in Openhab - Version 0.3 by eiGelbGeek#
#https://github.com/eiGelbGeek/itunes-api                                      #
################################################################################

itunesAPI_URL="XXX.XXX.XXX.XXX"
itunesAPI_Port="8181"

openhab_url="XXX.XXX.XXX.XXX"
openhab_port="8080"

#Ab hier sind keine Änderungen mehr nötig!
case $1 in
    volume)
        #$2 = 0-100 $3 = Airplay_ID
        curl -X PUT -d "level=$2" http://$itunesAPI_URL:$itunesAPI_Port/airplay_devices/$3/volume
        ;;
    get_set_volume)
        #$2 = Airplay_ID - $3 = Openhab Dimmer für Volume
        if AP_Volume="$(curl -s GET --header "Accept: application/json" "http://$itunesAPI_URL:$itunesAPI_Port/airplay_devices/$2" | jq -r '.sound_volume' 2>/dev/null)";
        then
          curl -X POST --header "Content-Type: text/plain" --header "Accept: application/json" -d "$AP_Volume" "http://$openhab_url:$openhab_port/rest/items/$3"
        else
          curl -X POST --header "Content-Type: text/plain" --header "Accept: application/json" -d "0" "http://$openhab_url:$openhab_port/rest/items/$3"
          exit 1
        fi
        ;;
    play)
        curl -X PUT http://$itunesAPI_URL:$itunesAPI_Port/play
        ;;
    playpause)
        curl -X PUT http://$itunesAPI_URL:$itunesAPI_Port/playpause
        ;;
    pause)
        curl -X PUT http://$itunesAPI_URL:$itunesAPI_Port/pause
        ;;
    stop)
        curl -X PUT http://$itunesAPI_URL:$itunesAPI_Port/stop
        ;;
    stop_on_pause)
        #Needed when transferring metadata with EventScripts!
        curl -X PUT http://$itunesAPI_URL:$itunesAPI_Port/play
        curl -X PUT http://$itunesAPI_URL:$itunesAPI_Port/stop
        ;;
    previous)
        curl -X PUT http://$itunesAPI_URL:$itunesAPI_Port/previous
        ;;
    next)
        curl -X PUT http://$itunesAPI_URL:$itunesAPI_Port/next
        ;;
    mute)
        #$2 = true/false
        curl -X PUT -d "muted=$2" http://$itunesAPI_URL:$itunesAPI_Port/mute
        ;;
    shuffle)
        #$2 = off/songs/albums/groupings
        curl -X PUT -d "mode=$2" http://$itunesAPI_URL:$itunesAPI_Port/shuffle
        ;;
    get_set_shuffle)
        #$2 = Openhab Number Item für Shuffle
        if shuffle="$(curl -s GET --header "Accept: application/json" "http://$itunesAPI_URL:$itunesAPI_Port/now_playing" | jq -r '.shuffle' 2>/dev/null)";
          then
            if [ "$shuffle" == "off" ]; then
              curl -X POST --header "Content-Type: text/plain" --header "Accept: application/json" -d "0" "http://$openhab_url:$openhab_port/rest/items/$2"
            elif [ "$shuffle" == "songs" ]; then
              curl -X POST --header "Content-Type: text/plain" --header "Accept: application/json" -d "1" "http://$openhab_url:$openhab_port/rest/items/$2"
            elif [ "$shuffle" == "albums" ]; then
              curl -X POST --header "Content-Type: text/plain" --header "Accept: application/json" -d "2" "http://$openhab_url:$openhab_port/rest/items/$2"
            elif [ "$shuffle" == "groupings" ]; then
              curl -X POST --header "Content-Type: text/plain" --header "Accept: application/json" -d "3" "http://$openhab_url:$openhab_port/rest/items/$2"
            fi
        else
          exit 1
        fi
        ;;
    repeat)
        #$2 = off/one/all
        curl -X PUT -d "mode=$2" http://$itunesAPI_URL:$itunesAPI_Port/repeat
        ;;
    get_set_repeat)
        #$2 = Openhab Number Item für Repeat
        if repeat="$(curl -s GET --header "Accept: application/json" "http://$itunesAPI_URL:$itunesAPI_Port/now_playing" | jq -r '.repeat' 2>/dev/null)";
          then
            if [ "$repeat" == "off" ]; then
              curl -X POST --header "Content-Type: text/plain" --header "Accept: application/json" -d "0" "http://$openhab_url:$openhab_port/rest/items/$2"
            elif [ "$repeat" == "one" ]; then
              curl -X POST --header "Content-Type: text/plain" --header "Accept: application/json" -d "1" "http://$openhab_url:$openhab_port/rest/items/$2"
            elif [ "$repeat" == "all" ]; then
              curl -X POST --header "Content-Type: text/plain" --header "Accept: application/json" -d "2" "http://$openhab_url:$openhab_port/rest/items/$2"
            fi
        else
          exit 1
        fi
        ;;
    airplay_on)
        #$2 = Airplay_ID - $3 = Openhab Switch Item für Airplay Device - $4 = Openhab Switch Item für Airplay Device Status
        if AP_Selected="$(curl -s GET --header "Accept: application/json" "http://$itunesAPI_URL:$itunesAPI_Port/airplay_devices/$2" | jq -r '.selected' 2>/dev/null)";
        then
          if $AP_Selected == "true";
          then
            curl -X POST --header "Content-Type: text/plain" --header "Accept: application/json" -d "ON" "http://$openhab_url:$openhab_port/rest/items/$4"
          else
            curl -X PUT http://$itunesAPI_URL:$itunesAPI_Port/airplay_devices/$2/on
            curl -X POST --header "Content-Type: text/plain" --header "Accept: application/json" -d "ON" "http://$openhab_url:$openhab_port/rest/items/$4"
          fi
        else
          curl -X POST --header "Content-Type: text/plain" --header "Accept: application/json" -d "OFF" "http://$openhab_url:$openhab_port/rest/items/$4"
          curl -X POST --header "Content-Type: text/plain" --header "Accept: application/json" -d "OFF" "http://$openhab_url:$openhab_port/rest/items/$3"
        	exit 1
        fi
        ;;
    airplay_off)
        #$2 = Airplay_ID - $3 = Openhab Switch Item für Airplay Device Status
        if AP_Selected="$(curl -s GET --header "Accept: application/json" "http://$itunesAPI_URL:$itunesAPI_Port/airplay_devices/$2" | jq -r '.selected' 2>/dev/null)";
        then
          if $AP_Selected == "true";
          then
            curl -X PUT http://$itunesAPI_URL:$itunesAPI_Port/airplay_devices/$2/off
            curl -X POST --header "Content-Type: text/plain" --header "Accept: application/json" -d "OFF" "http://$openhab_url:$openhab_port/rest/items/$3"
          else
            curl -X POST --header "Content-Type: text/plain" --header "Accept: application/json" -d "OFF" "http://$openhab_url:$openhab_port/rest/items/$3"
          fi
          curl -X POST --header "Content-Type: text/plain" --header "Accept: application/json" -d "OFF" "http://$openhab_url:$openhab_port/rest/items/$3"
          exit 1
        fi
        ;;
    playlist)
        #$2 = Playlist ID
        playlist_ids=( one two three )
        curl -X PUT http://$itunesAPI_URL:$itunesAPI_Port/playlists/${playlist_ids[$2]}/play
        ;;
    webradio)
        curl -X PUT http://$itunesAPI_URL:$itunesAPI_Port/webradio/$2
        ;;
    addMedia)
        curl -X PUT http://$itunesAPI_URL:$itunesAPI_Port/addMedia/$2
        ;;
    system)
        curl -X PUT http://$itunesAPI_URL:$itunesAPI_Port/system/$2
        ;;
    *)
        echo "Kommando nicht vorhanden!"
        ;;
esac
