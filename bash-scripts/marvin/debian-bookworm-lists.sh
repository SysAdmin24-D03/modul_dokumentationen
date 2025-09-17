#!/bin/sh
# setup-hetzner-sources.sh
# Richtet Hetzner-Mirror für Debian 12 (bookworm) ein

set -eu

# Root-Check
if [ "$(id -u)" -ne 0 ]; then
  echo "Bitte als root ausführen." >&2
  exit 1
fi

# Bestehende sources.list sichern (mit Zeitstempel)
if [ -f /etc/apt/sources.list ]; then
  mv /etc/apt/sources.list "/etc/apt/sources.list.$(date +%Y%m%d-%H%M%S).bak"
fi

# Zielverzeichnis sicherstellen
mkdir -p /etc/apt/sources.list.d

# Hetzner-Mirror eintragen
cat >/etc/apt/sources.list.d/hetzner-mirror.list <<'EOF'
# Packages & Security Updates vom Hetzner Debian Mirror
deb https://mirror.hetzner.com/debian/packages  bookworm           main contrib non-free non-free-firmware
deb https://mirror.hetzner.com/debian/packages  bookworm-updates   main contrib non-free non-free-firmware
deb https://mirror.hetzner.com/debian/packages  bookworm-backports main contrib non-free non-free-firmware
deb https://mirror.hetzner.com/debian/security  bookworm-security  main contrib non-free non-free-firmware
EOF

# Paketlisten aktualisieren
apt-get update
echo "Fertig: Hetzner-Mirror gesetzt und Paketlisten aktualisiert."
