#!/bin/bash"
mkdir -p $HOME/logs
ngrok config add-authtoken $NGROK_AUTH_TOKEN
ngrok http $NGROK_TUNNEL_PORT --url=$NGROK_TUNNEL_URL --log=$NGROK_LOG