#!/bin/bash
export REMOTE_REPO="https://raw.githubusercontent.com/MartinSIbarra/localhost-configs/refs/heads/main/files"

exec_until_done() {
  local n=0
  local max=10
  local delay=3

  echo "$@"
  until "$@"; do
    n=$((n+1))  
    if [ $n -ge $max ]; then
      echo "Comando falló tras $n intentos: $*"
      return 1
    fi
    echo "Intento $n fallido. Reintentando en $delay segundos..."
    sleep $delay
  done
}
export -f exec_until_done

echo "🔧 > Agregando variables de entorno para DevOps..."
    REMOTE_DEVOPS_VARS=$REMOTE_REPO/devops.env
    DEVOPS_VARS=$HOME/.config/$(basename $REMOTE_DEVOPS_VARS)
    echo "DEVOPS_VARS: $DEVOPS_VARS"
    echo "REMOTE_DEVOPS_VARS: $REMOTE_DEVOPS_VARS"
    exec_until_done curl -sSfL -o $DEVOPS_VARS $REMOTE_DEVOPS_VARS || { echo "Error descargando $REMOTE_DEVOPS_VARS"; exit 1; }
    
    [[ -r "$HOME/.config/ngrok-auth-token" ]] && NGROK_AUTH_TOKEN=$(head -n 1 $HOME/.config/ngrok-auth-token)
    [[ -n "$NGROK_AUTH_TOKEN" ]] && sed -i "s/XXXngrok-auth-tokenXXX/$NGROK_AUTH_TOKEN/g" $DEVOPS_VARS
    rm -f $HOME/.config/ngrok-auth-token
    
    [[ -r "$HOME/.config/ngrok-tunnel-url" ]] && NGROK_TUNNEL_URL=$(head -n 1 $HOME/.config/ngrok-tunnel-url)
    [[ -n "$NGROK_TUNNEL_URL" ]] && sed -i "s/XXXngrok-tunnel-urlXXX/$NGROK_TUNNEL_URL/g" $DEVOPS_VARS
    rm -f $HOME/.config/ngrok-tunnel-url
    
    echo "set -a && source $DEVOPS_VARS && set +a" >> $HOME/.config/customs.sh
    set -a && source $DEVOPS_VARS && set +a
echo "✅ > Variables de entorno para DevOps agregadas."

TUNNEL_INSTALL_SCRIPT=$REMOTE_REPO/tunnel-install.sh
echo "TUNNEL_INSTALL_SCRIPT: $TUNNEL_INSTALL_SCRIPT"
exec_until_done curl -sSfL $TUNNEL_INSTALL_SCRIPT | bash

TUNNEL_CONFIG_SCRIPT=$REMOTE_REPO/tunnel-config.sh
echo "TUNNEL_CONFIG_SCRIPT: $TUNNEL_CONFIG_SCRIPT"
exec_until_done curl -sSfL $TUNNEL_CONFIG_SCRIPT | bash
