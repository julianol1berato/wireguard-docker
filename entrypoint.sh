#!/bin/sh

# Caminho para as configurações do WireGuard
WG_CONF_DIR="/etc/wireguard"
WG_CONF="$WG_CONF_DIR/wg0.conf"

# Verifique se o arquivo .wg0 existe
if [ ! -f "$WG_CONF" ]; then
    echo "Arquivo wg0.conf não encontrado em $WG_CONF_DIR"
    exit 1
fi

wg-quick up wg0

tail -f /dev/null
