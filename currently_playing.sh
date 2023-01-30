#/bin/bash
if [ -f "api_key" ];
then
  APIKEY="`cat api_key`"
else
  read -p "API KEY: " APIKEY 
fi

while true
do
  API_DATA="`curl -X GET "https://api.spotify.com/v1/me/player/currently-playing" -H "Authorization: Bearer $APIKEY" --silent`" 
  echo $API_DATA | grep -E "The access token expired" > /dev/null && echo "Api key expired, generate a new one." && exit 1
  echo $API_DATA | grep -E "Invalid access token" > /dev/null && echo "Invalid Api key (try generating a new one)." && exit 1
  echo $API_DATA | grep -E "Service unavailable" > /dev/null && echo "Api limit, please wait." && sleep 15 && continue
  echo "$API_DATA" | sed -n "2p" | grep -E "error" && echo "$API_DATA" >> last_error && echo "Unknown error (try generating a new api key)."
  if [ -z "$API_DATA" ];
  then
    echo "No song playing" > current_song
    sleep 15
    continue
  else
    NAMES=`echo "$API_DATA" | grep -E "name"`
    ARTIST=`echo $NAMES | cut -d ':' -f2 | cut -d '"' -f2`
    SONG=`echo $NAMES | cut -d ':' -f5 | cut -d '"' -f2`
    [ -n "$ARTIST" ] && [ -n "$SONG" ] && echo "$ARTIST - $SONG" > current_song
  fi
  sleep 15
done
