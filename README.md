# wireguard-docker



#### lado servidor, necessário apresentar wg0.conf
utilitário de config: 
<a href="https://www.wireguardconfig.com/">`https://www.wireguardconfig.com/`</a>
<br><br>

**wg0.conf**
```sh
[Interface]
Address =  100.101.255.1/29
ListenPort = PORT_EXT
PrivateKey = CHAVEPVT
PostUp = iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE; iptables -A INPUT -p udp -m udp --dport PORT_EXT -j ACCEPT; iptables -A FORWARD -i wg0 -j ACCEPT; iptables -A FORWARD -o wg0 -j ACCEPT;
PostDown = iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE; iptables -D INPUT -p udp -m udp --dport PORT_EXT -j ACCEPT; iptables -D FORWARD -i wg0 -j ACCEPT; iptables -D FORWARD -o wg0 -j ACCEPT;


[Peer]
PublicKey = PUB
PresharedKey = PRIV
AllowedIPs = 100.101.255.2/32
```

#### lado peer

```sh
[Interface]
PrivateKey = 
Address = 100.101.255.2/29
DNS = 1.1.1.1
MTU = 1412

[Peer]
PublicKey = NOQ
PresharedKey = 
AllowedIPs = 9.9.9.9/32, 100.101.255.1/29
Endpoint = 17XXXX:13731
PersistentKeepalive = 25

```
