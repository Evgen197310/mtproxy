#!/bin/bash
# Update MTProxy configuration from Telegram servers
curl -s https://core.telegram.org/getProxySecret -o /opt/mtproxy/proxy-secret
curl -s https://core.telegram.org/getProxyConfig -o /opt/mtproxy/proxy-multi.conf
systemctl restart MTProxy
