#!/usr/bin/env bash
# Falls abweichende Werte angezeigt werden, wird n/a angezeigt.
# Interne IPs (erstes IPv4 / erstes IPv6 aus hostname -I)
ip4i=$(hostname -I 2>/dev/null | awk '{for(i=1;i<=NF;i++) if($i!~/:/){print $i; exit}}')
ip6i=$(hostname -I 2>/dev/null | awk '{for(i=1;i<=NF;i++) if($i~/:/){print $i; exit}}')

# Externe IPs (einfach per curl)
ip4e=$(curl -4 -s https://api.ipify.org 2>/dev/null)
[[ $ip4e == *.* ]] || ip4e=""   # nur anzeigen, wenn es wie IPv4 aussieht

ip6e=$(curl -6 -s https://api64.ipify.org 2>/dev/null)
[[ $ip6e == *:* ]] || ip6e=""   # nur anzeigen, wenn es wie IPv6 aussieht

echo "################################"
echo "# [V4]"
echo "# Private IP = ${ip4i:-n/a}"
echo "# Öffentliche IP = ${ip4e:-n/a}"
echo "################################"
echo
echo "################################"
echo "# [V6]"
echo "# Private IP = ${ip6i:-n/a}"
echo "# Öffentliche IP = ${ip6e:-n/a}"
echo "################################"
