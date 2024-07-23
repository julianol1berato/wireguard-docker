#!/bin/sh

# Caminho para as configurações do WireGuard
WG_CONF_DIR="/etc/wireguard"
WG_CONF="$WG_CONF_DIR/wg0.conf"
ENV_FILE="$WG_CONF_DIR/.env"

# Verifique se o arquivo .env existe
if [ ! -f "$ENV_FILE" ]; then
    echo "Arquivo .env não encontrado em $WG_CONF_DIR."
    echo "Por favor, crie um arquivo .env com base no exemplo fornecido (.env.example)."
    exit 1
fi

# Carregar variáveis de ambiente do arquivo .env
set -a
. "$ENV_FILE"
set +a

# Crie os diretórios necessários
mkdir -p /etc/wireguard /var/run/wireguard

# Verifique se a configuração já existe
if [ ! -f "$WG_CONF" ]; then
    echo "Gerando nova configuração do WireGuard..."

    # Geração das chaves
    umask 077
    wg genkey | tee privatekey | wg pubkey > publickey

    # Criação do arquivo de configuração
    cat <<EOF > $WG_CONF
[Interface]
PrivateKey = $(cat privatekey)
Address = $WG_ADDRESS
ListenPort = $WG_LISTEN_PORT
PersistentKeepalive = $WG_PERSISTENT_KEEPALIVE

[Peer]
PublicKey = $PEER_PUBLIC_KEY
AllowedIPs = $PEER_ALLOWED_IPS
Endpoint = $PEER_ENDPOINT
EOF

    echo "Configuração do WireGuard gerada em $WG_CONF"
fi

# Inicialize o WireGuard
echo "Iniciando o WireGuard..."
wg-quick up wg0

# Manter o contêiner em execução
tail -f /dev/null
