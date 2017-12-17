#!/bin/bash

#######################################################################################
#BashScript zur Dynamischen Playlist Verwaltung in Openhab - Version 0.3 by eiGelbGeek#
#######################################################################################

itunesAPI_URL="XXX.XXX.XXX.XXX"
itunesAPI_Port="8181"
oh_sitemap_dir="/etc/openhab2/sitemaps"
oh_sitemap_name="YOURSITEMAP.sitemap"
oh_script_dir="/etc/openhab2/scripts"
oh_playlist_item="playlist_selection"

###########################################
#Ab hier sind keine Änderungen mehr nötig!#
###########################################

> /tmp/itunes_playlist_names.txt
> /tmp/itunes_playlist_ids.txt
#Playlisten Namen abfragen und in Temporäre Datei schreiben!
curl -s GET --header "Accept: application/json" "http://$itunesAPI_URL:$itunesAPI_Port/playlists" | jq '.playlists[] | .name' > /tmp/itunes_playlist_names.txt
#Zeile 1-7 löschen! (iTunes Standard Playlisten!!)
sed -i 1,7D /tmp/itunes_playlist_names.txt
#Erforderliche Formatierung für Sitemap hinzufügen!
cp /tmp/itunes_playlist_names.txt /tmp/itunes_playlist_names_tmp.txt
awk '{print NR"="$0", "}' /tmp/itunes_playlist_names_tmp.txt > /tmp/itunes_playlist_names.txt
rm /tmp/itunes_playlist_names_tmp.txt
#Datei vervollständigen!
sed -i '1 i\0="Playlist auswählen",' /tmp/itunes_playlist_names.txt
sed -i '1 i\Selection item=playlist_selection label="Playliste" icon="playlist" mappings=[' /tmp/itunes_playlist_names.txt
sed -i '$s/.\{2\}$//' /tmp/itunes_playlist_names.txt
echo "]" >> /tmp/itunes_playlist_names.txt
cp /tmp/itunes_playlist_names.txt /tmp/itunes_playlist_names_tmp.txt
tr -s '\n' ' ' < /tmp/itunes_playlist_names_tmp.txt > /tmp/itunes_playlist_names.txt
rm /tmp/itunes_playlist_names_tmp.txt
varPlaylistNames=$(cat /tmp/itunes_playlist_names.txt)
#Playlist Selection in Sitemap suchen und ersetzen
sed -i 's/\Selection item='"$oh_playlist_item"'\b.*/'"$varPlaylistNames"'/g' $oh_sitemap_dir/$oh_sitemap_name
#Dateirechte setzen!
cd $oh_sitemap_dir
chown openhab:openhab $oh_sitemap_name

#Playlisten IDs abfragen und in Temporäre Datei schreiben!
curl -s GET --header "Accept: application/json" "http://$itunesAPI_URL:$itunesAPI_Port/playlists" | jq -r '.playlists[] | .id' > /tmp/itunes_playlist_ids.txt
#Zeile 1-7 löschen! (iTunes Standard Playlisten!!)
sed -i 1,7D /tmp/itunes_playlist_ids.txt
#Datei vervollständigen!
sed -i '1 i\playlist_ids=( dummy' /tmp/itunes_playlist_ids.txt
echo ")" >> /tmp/itunes_playlist_ids.txt
cp /tmp/itunes_playlist_ids.txt /tmp/itunes_playlist_ids_tmp.txt
tr -s '\n' ' ' < /tmp/itunes_playlist_ids_tmp.txt > /tmp/itunes_playlist_ids.txt
rm /tmp/itunes_playlist_ids_tmp.txt
varPlaylistIDs=$(cat /tmp/itunes_playlist_ids.txt)
sed -i 's/\'"playlist_ids=( "'\b.*/'"$varPlaylistIDs"'/g' $oh_script_dir/oh_itunes-api.sh
#Dateirechte setzen!
cd $oh_script_dir
chown openhab:openhab oh_itunes-api.sh
chmod u+x oh_itunes-api.sh
