#!/bin/sh

SERVER="9025 --auth john-peters:malac0da"

# Create list of torrent IDs
TORRENTLIST=`transmission-remote $SERVER --list | sed -e '1d;$d;s/^ *//' | cut --only-delimited --delimiter=" " --fields=1`

#check status of each torrent in list for '100%'
for i in $TORRENTLIST; do
    echo $i
	if `transmission-remote $SERVER --torrent $i --info | grep -q "Percent Done: 100%"`; then
		# write finished file title into text file
		transmission-remote $SERVER --torrent $i --info | sed -e '3q;d' | cut -d' ' -f4- >> ~/finished-torrents.txt
		
		# remove torrent
		transmission-remote $SERVER --torrent $i --remove
		
	fi
done
