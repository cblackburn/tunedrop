#!/bin/bash

status() {
  state=`osascript -e 'tell application "iTunes" to player state as string'`
  if [ $state = "playing" ]; then
    echo "PLAYING"
  else
    echo "NOT_PLAYING"
  fi
}

post_song() {
  curl -X "POST" "http://localhost:4000/api/songs" \
  	-H "Content-Type: application/json" \
  	-H "x-api-key: rmfGBxMlnc2jjKAEvrtyRA" \
  	-H "Accept: application/json" \
  	-d "{\"song\":{\"artist\":\"$artist\",\"track\":\"$track\",\"year\":\"$year\"}}"
}

if [ `status` = "PLAYING" ]; then
  artist=`osascript -e 'tell application "iTunes" to artist of current track as string'`;
  track=`osascript -e 'tell application "iTunes" to name of current track as string'`;
  year=`osascript -e 'tell application "iTunes" to year of current track as string'`;
  post_song
fi
