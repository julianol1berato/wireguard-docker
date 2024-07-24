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

RUN mkdir -p /usr/local/bin /etc/wireguard
EXPOSE 13731/udp
CMD ["sh", "-c", "sleep 5 && wg-quick up wg0 && tail -f /dev/null"]
