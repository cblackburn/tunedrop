#!/bin/bash

if [ -z "$TUNEDROP_API_KEY" ]; then
  echo "You must set your TUNEDROP_API_KEY environment var before running this script."
  exit 1
fi

status() {
  state=`osascript -e 'tell application "iTunes" to player state as string'`
  if [ $state = "playing" ]; then
    echo "PLAYING"
  else
    echo "NOT_PLAYING"
  fi
}

post_song() {
  curl -X "POST" "https://songdrop.herokuapp.com/api/songs" \
  	-H "Content-Type: application/json" \
  	-H "x-api-key: $TUNEDROP_API_KEY" \
  	-H "Accept: application/json" \
  	-d "{\"song\":{\"artist\":\"$artist\",\"track\":\"$track\",\"year\":\"$year\"}}"
}

if [ `status` = "PLAYING" ]; then
  artist=`osascript -e 'tell application "iTunes" to artist of current track as string'`;
  track=`osascript -e 'tell application "iTunes" to name of current track as string'`;
  year=`osascript -e 'tell application "iTunes" to year of current track as string'`;
  post_song
fi
