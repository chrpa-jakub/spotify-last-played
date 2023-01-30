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
if [ "$API_DATA" = "" ];
then
  echo "No song playing."
else
  NAMES=`echo "$API_DATA" | grep -E "name"`
  ARTIST=`echo $NAMES | cut -d '"' -f4`
  SONG=`echo $NAMES | cut -d '"' -f16`
  echo "$ARTIST - $SONG" > current_song 
fi
sleep 5
done
