#!/bin/bash
REMOTE_REPO=https://raw.githubusercontent.com/MartinSIbarra/localhost-configs/main

BASICS_SCRIPT=$REMOTE_REPO/files/basics.sh
curl -sL $BASICS_SCRIPT | bash

echo "🔧 > Agregando variables de entorno para DevOps..."
    REMOTE_DEVOPS_VARS=$REMOTE_REPO/files/devops-vars
    DEVOPS_VARS=$HOME/.config/$(basename $REMOTE_DEVOPS_VARS)
    curl -fL -C - -o $DEVOPS_VARS $REMOTE_DEVOPS_VARS || { echo "Error descargando $REMOTE_DEVOPS_VARS"; exit 1; }
    echo "set -a && source $DEVOPS_VARS && set +a" >> $HOME/.config/customs.sh
    set -a && source $DEVOPS_VARS && set +a
echo "✅ > Variables de entorno para DevOps agregadas."

TUNNEL_INSTALL_SCRIPT=$REMOTE_REPO/files/tunnel-install.sh
curl -sL $TUNNEL_INSTALL_SCRIPT | bash

TUNNEL_CONFIG_SCRIPT=$REMOTE_REPO/files/tunnel-config.sh
curl -sL $TUNNEL_CONFIG_SCRIPT | bash