#!/bin/bash
export REMOTE_REPO="https://raw.githubusercontent.com/MartinSIbarra/localhost-configs/refs/heads/main"

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

echo "🔧 > Actualizando el Package Manager..."
    sudo apt-get update
    sudo apt-get upgrade -y
echo "✅ > Package Manager actualizado."

echo "🔧 > Instalando Paquetes y dependencias..."
    sudo apt-get install -y \
        apt-transport-https ca-certificates gnupg2 software-properties-common locales gettext \
        build-essential dkms linux-headers-$(uname -r) curl busybox git vim wget unzip
echo "✅ > Paquetes y dependencias instalados."

echo "🔧 > Agregado carpetas de configuraciones, logs y ejecutables..."
    mkdir -p $HOME/.config
    rm -f $HOME/.config/customs.sh && touch $HOME/.config/customs.sh
    chmod +x $HOME/.config/customs.sh
    chown $USER:$USER $HOME/.config/customs.sh
    echo "source $HOME/.config/customs.sh" >> $HOME/.bashrc

    mkdir -p $HOME/logs
    
    mkdir -p $HOME/bin
    echo "export PATH=$HOME/bin:\$PATH" >> $HOME/.config/customs.sh    
echo "✅ > Carpetas de configuraciones, logs y ejecutables agregadas."

echo "🔧 > Agregando variables de entorno..."
# Variables para obtener los archivos del repositorio remoto
    REMOTE_BASICS_VARS=$REMOTE_REPO/files/basics-vars
    BASICS_VARS=$HOME/.config/$(basename $REMOTE_BASICS_VARS)
    echo "BASICS_VARS: $BASICS_VARS"
    echo "REMOTE_BASICS_VARS: $REMOTE_BASICS_VARS"
    exec_until_done curl -sSfL -o $BASICS_VARS $REMOTE_BASICS_VARS || { echo "Error descargando $REMOTE_BASICS_VARS"; exit 1; }
    echo "set -a && source $BASICS_VARS && set +a" >> $HOME/.config/customs.sh
    set -a && source $BASICS_VARS && set +a
echo "✅ > Variables de entorno agregadas."

echo "🔧 > Agregando aliases customs..."
    REMOTE_ALIAS_SCRIPT=$REMOTE_REPO/files/aliases.sh
    ALIAS_SCRIPT="$HOME/.config/$(basename $REMOTE_ALIAS_SCRIPT)"
    echo "ALIAS_SCRIPT: $ALIAS_SCRIPT"
    echo "REMOTE_ALIAS_SCRIPT: $REMOTE_ALIAS_SCRIPT"
    exec_until_done curl -sSfL -o $ALIAS_SCRIPT $REMOTE_ALIAS_SCRIPT || { echo "Error descargando $REMOTE_ALIAS_SCRIPT"; exit 1; }
    chmod +x $ALIAS_SCRIPT
    chown $USER:$USER $ALIAS_SCRIPT
    echo "source $ALIAS_SCRIPT" >> $HOME/.config/customs.sh
echo "✅ > Alias customs agregados."

echo "🔧 > Configurando locales es_AR.UTF-8 y lenguaje en_US.UTF-8..."
    # Asegurarse de que esté habilitado en /etc/locale.gen
    if ! grep -q "^es_AR.UTF-8 UTF-8" /etc/locale.gen; then
        echo "es_AR.UTF-8 UTF-8" | sudo tee -a /etc/locale.gen
    fi
    sudo locale-gen
    REMOTE_LOCALE_VARS=$REMOTE_REPO/files/locale-vars
    echo "REMOTE_LOCALE_VARS: $REMOTE_LOCALE_VARS"
    exec_until_done sudo curl -sSfL -o /etc/default/locale $REMOTE_LOCALE_VARS || { echo "Error descargando $REMOTE_LOCALE_VARS"; exit 1; }
    set -a && source /etc/default/locale && set +a
echo "✅ > Locales configurados correctamente."

echo "🔧 > Configurando zona horaria..."
    sudo timedatectl set-ntp true
    sudo timedatectl set-timezone America/Argentina/Buenos_Aires
echo "✅ > Zona horaria configurada."