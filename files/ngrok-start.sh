#!/bin/bash
mkdir -p $HOME/logs
NGROK_AUTH_TOKEN=$(cat $NGROK_AUTH_TOKEN_PATH)
ngrok http $NGROK_TUNNEL_PORT --url=$NGROK_TUNNEL_URL --authtoken=$NGROK_AUTH_TOKEN --log=$NGROK_LOG