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

# Adicione o script de inicialização diretamente no Dockerfile
RUN mkdir -p /usr/local/bin /etc/wireguard && \
    echo '#!/bin/sh\n\
    WG_CONF_DIR="/etc/wireguard"\n\
    WG_CONF="$WG_CONF_DIR/wg0.conf"\n\
    if [ ! -f "$WG_CONF" ]; then\n\
        echo "Arquivo de configuração do WireGuard não encontrado em $WG_CONF_DIR."\n\
        exit 1\n\
    fi\n\
    echo "Iniciando o WireGuard..."\n\
    wg-quick up wg0\n\
    tail -f /dev/null\n' > /usr/local/bin/entrypoint.sh && \
    chmod +x /usr/local/bin/entrypoint.sh

# Copie o arquivo de configuração wg0.conf
COPY wg0.conf /etc/wireguard/wg0.conf

# Exponha a porta do WireGuard
EXPOSE 13731/udp

# Comando para iniciar o WireGuard
CMD ["/usr/local/bin/entrypoint.sh"]
