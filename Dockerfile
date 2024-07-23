# Use a imagem oficial do Alpine como base
FROM alpine:latest

# Atualize o sistema e instale os pacotes necessários
RUN apk update && apk add --no-cache \
    wireguard-tools \
    iproute2 \
    iptables \
    curl \
    tcpdump \
    neovim \
    bash \
    && rm -rf /var/cache/apk/*

# Copie um script de inicialização para o contêiner
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# Torne o script de inicialização executável
RUN chmod +x /usr/local/bin/entrypoint.sh

# Crie um exemplo de arquivo .env
RUN mkdir -p /etc/wireguard && \
    echo 'WG_ADDRESS=10.0.0.1/24\n\
WG_LISTEN_PORT=51820\n\
WG_PERSISTENT_KEEPALIVE=25\n\
PEER_PUBLIC_KEY=CHAVE_PUBLICA_DO_PEER\n\
PEER_ALLOWED_IPS=10.0.0.2/32\n\
PEER_ENDPOINT=peer.example.com:51820\n' > /etc/wireguard/.env

# Exponha a porta do WireGuard
EXPOSE 51820/udp

# Comando para iniciar o WireGuard
CMD ["/usr/local/bin/entrypoint.sh"]
