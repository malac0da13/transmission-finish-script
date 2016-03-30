#!/bin/sh

SERVER="9025 --auth john-peters:malac0da"

NUMTORRENTS=`transmission-remote $SERVER --list | wc -l`
let NUMTORRENTS-=2

for ((i=1; i<=NUMTORRENTS; i++)); do
	if `transmission-remote $SERVER --torrent $i --info | grep -q "Percent Done: 100%"`; then
		# write finished file title into text file
		transmission-remote $SERVER --torrent $i --info | sed -e '3q;d' | cut -d' ' -f4- >> ~/finished-torrents.txt
		
		# remove torrent
		transmission-remote $SERVER --torrent $i --remove
		
	fi
done
