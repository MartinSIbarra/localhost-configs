#!/bin/bash
export REMOTE_REPO="https://raw.githubusercontent.com/MartinSIbarra/localhost-configs/refs/heads/main"

BASICS_SCRIPT=$REMOTE_REPO/files/basics.sh
echo "BASICS_SCRIPT: $BASICS_SCRIPT"
curl -sL $BASICS_SCRIPT | bash

echo "🔧 > Agregando variables de entorno para DevOps..."
    REMOTE_DEVOPS_VARS=$REMOTE_REPO/files/devops-vars
    DEVOPS_VARS=$HOME/.config/$(basename $REMOTE_DEVOPS_VARS)
    echo "DEVOPS_VARS: $DEVOPS_VARS"
    echo "REMOTE_DEVOPS_VARS: $REMOTE_DEVOPS_VARS"
    curl -fL -C - -o $DEVOPS_VARS $REMOTE_DEVOPS_VARS || { echo "Error descargando $REMOTE_DEVOPS_VARS"; exit 1; }
    echo "set -a && source $DEVOPS_VARS && set +a" >> $HOME/.config/customs.sh
    set -a && source $DEVOPS_VARS && set +a
echo "✅ > Variables de entorno para DevOps agregadas."

TUNNEL_INSTALL_SCRIPT=$REMOTE_REPO/files/tunnel-install.sh
echo "TUNNEL_INSTALL_SCRIPT: $TUNNEL_INSTALL_SCRIPT"
curl -sL $TUNNEL_INSTALL_SCRIPT | bash

TUNNEL_CONFIG_SCRIPT=$REMOTE_REPO/files/tunnel-config.sh
echo "TUNNEL_CONFIG_SCRIPT: $TUNNEL_CONFIG_SCRIPT"
curl -sL $TUNNEL_CONFIG_SCRIPT | bash