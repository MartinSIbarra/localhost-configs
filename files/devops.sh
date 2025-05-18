#!/bin/bash
# Valores por defecto
echo "🔧 > Agregando variables de entorno para DevOps..."
    REMOTE_DEVOPS_ENV=$REMOTE_REPO/devops.env
    DEVOPS_ENV=$HOME/.config/$(basename $REMOTE_DEVOPS_ENV)
    echo "DEVOPS_ENV: $DEVOPS_ENV"
    echo "REMOTE_DEVOPS_ENV: $REMOTE_DEVOPS_ENV"
    exec_until_done curl -sSfL -o $DEVOPS_ENV $REMOTE_DEVOPS_ENV || { echo "Error descargando $REMOTE_DEVOPS_ENV"; exit 1; }
    
    [[ -n "$NGROK_AUTH_TOKEN" ]] && sed -i "s/XXXngrok-auth-tokenXXX/$NGROK_AUTH_TOKEN/g" $DEVOPS_ENV
    [[ -n "$NGROK_TUNNEL_URL" ]] && sed -i "s/XXXngrok-tunnel-urlXXX/$NGROK_TUNNEL_URL/g" $DEVOPS_ENV
    
    echo "set -a && source $DEVOPS_ENV && set +a" >> $HOME/.config/customs.sh
    set -a && source $DEVOPS_ENV && set +a
echo "✅ > Variables de entorno para DevOps agregadas."

TUNNEL_INSTALL_SCRIPT=$REMOTE_REPO/tunnel-install.sh
echo "TUNNEL_INSTALL_SCRIPT: $TUNNEL_INSTALL_SCRIPT"
exec_until_done curl -sSfL $TUNNEL_INSTALL_SCRIPT | bash

TUNNEL_CONFIG_SCRIPT=$REMOTE_REPO/tunnel-config.sh
echo "TUNNEL_CONFIG_SCRIPT: $TUNNEL_CONFIG_SCRIPT"
exec_until_done curl -sSfL $TUNNEL_CONFIG_SCRIPT | bash
