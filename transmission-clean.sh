#!/bin/bash
# Description:
# Checks for complete torrents in transmission, removes them from queue if global
# (or torrent's ratio) reached.

USER="$1"
PASSWORD="$1"

# get default ratio limit value
DEFAULT_RATIOLIMIT=`transmission-remote --auth=$USER:$PASSWORD -si | grep "Default seed ratio limit:" | cut -d \: -f 2 | sed 's/^ *//' | sed 's/[0]*$//g'`

# get torrent list from transmission-remote list
# delete first / last line of output
# remove leading spaces
# get first field from each line
TORRENTLIST=`transmission-remote --auth=$USER:$PASSWORD --list | sed -e '1d;$d;s/^ *//' | cut -s -d " " -f1`

# for each torrent in the list
for TORRENTID in $TORRENTLIST
do

    # use torrent own ratio limit, if present
    RATIOLIMIT=`transmission-remote --auth=$USER:$PASSWORD --torrent $TORRENTID --info | grep "Ratio Limit:" | cut -d \: -f 2 | sed 's/^ *//' | sed 's/[0]*$//g'`
    if [ $RATIOLIMIT = "Default" ]; then
        RATIOLIMIT=$DEFAULT_RATIOLIMIT
    fi

    # check if torrent was started
    STARTED=`transmission-remote --auth=$USER:$PASSWORD --torrent $TORRENTID --info | grep "Id: $TORRENTID" | sed 's/^ *//'`

    # check if torrent download is completed
    COMPLETED=`transmission-remote --auth=$USER:$PASSWORD --torrent $TORRENTID --info | grep "Percent Done: 100%" | sed 's/^ *//'`

    # check torrent's current state is "Stopped"
    STOPPED=`transmission-remote --auth=$USER:$PASSWORD --torrent $TORRENTID --info | grep "State: Finished" | sed 's/^ *//'`

    # check to see if ratio-limit-enabled is true
    if [ $RATIOLIMIT != "Unlimited" ]; then
        # check if torrent's ratio matches ratio-limit
        CAPPED=`transmission-remote --auth=$USER:$PASSWORD --torrent $TORRENTID --info | grep "Ratio: $RATIOLIMIT" | sed 's/^ *//'`
    else
        CAPPED=""
    fi

  # if the torrent is "Stopped" after downloading 100% and seeding, move the files and remove the torrent from Transmission
  if  [ "$STARTED" != "" ] && [ "$COMPLETED" != "" ] && [ "$STOPPED" != "" ] && [ "$CAPPED" != "" ]; then
    TR_TORRENT_NAME=`transmission-remote --auth=$USER:$PASSWORD --torrent $TORRENTID --info | grep -oP "(?<=Name: ).+"`
    transmission-remote --auth=$USER:$PASSWORD --torrent $TORRENTID --remove
  fi

done
