#!/usr/bin/env bash
# fancy-ip-open-both.sh – Offene Boxen (links & rechts), saubere Ausgabe

set -o pipefail

# --- Minimal-Autodetektion (nur wenn Variablen leer) -------------------------
ip4i="${ip4i:-$(hostname -I 2>/dev/null | awk '{for(i=1;i<=NF;i++) if($i!~/:/){print $i; exit}}')}"
ip6i="${ip6i:-$(hostname -I 2>/dev/null | awk '{for(i=1;i<=NF;i++) if($i~/:/){print $i; exit}}')}"
if command -v curl >/dev/null 2>&1; then
  ip4e="${ip4e:-$(curl -4 -s --connect-timeout 3 https://api.ipify.org || true)}"
  ip6e="${ip6e:-$(curl -6 -s --connect-timeout 3 https://api64.ipify.org || true)}"
fi
ip4i="${ip4i:-n/a}"; ip4e="${ip4e:-n/a}"
ip6i="${ip6i:-n/a}"; ip6e="${ip6e:-n/a}"

# --- Systeminfos --------------------------------------------------------------
DEF_IF="$(ip route 2>/dev/null | awk '/^default/ {print $5; exit}')"
GW4="$(ip route 2>/dev/null | awk '/^default/ {print $3; exit}')"
GW6="$(ip -6 route 2>/dev/null | awk '/^default/ {for(i=1;i<=NF;i++) if($i=="via"){print $(i+1); exit}}')"
DNS="$(awk '/^nameserver/ {print $2}' /etc/resolv.conf 2>/dev/null | paste -sd', ' -)"
HOST="$(hostname -f 2>/dev/null || hostname)"
MAC="$(cat "/sys/class/net/${DEF_IF}/address" 2>/dev/null)"
SSID=""
[[ -d "/sys/class/net/${DEF_IF}/wireless" ]] && SSID="$(iwgetid -r 2>/dev/null)"

# --- Terminal-Fähigkeiten ----------------------------------------------------
supports_color() { [[ -t 1 ]] && command -v tput >/dev/null && [[ $(tput colors 2>/dev/null) -ge 8 ]]; }
supports_utf8()  { locale | grep -qi 'utf-8'; }

if supports_color; then
  C_TITLE=$(tput setaf 6; tput bold)  # Cyan fett
  C_KEY=$(tput setaf 7)               # Hellgrau
  C_OK=$(tput setaf 2)                # Grün
  C_NA=$(tput setaf 1)                # Rot
  C_RST=$(tput sgr0)
else
  C_TITLE=""; C_KEY=""; C_OK=""; C_NA=""; C_RST=""
fi

if supports_utf8; then
  H="─"; SEP="─"
  ICON_V4="🧩"; ICON_V6="🧬"; ICON_PRIV="🔒"; ICON_PUB="🌍"; ICON_INFO="ℹ️ "
else
  H="-"; SEP="-"
  ICON_V4="V4"; ICON_V6="V6"; ICON_PRIV="PRIV"; ICON_PUB="PUB"; ICON_INFO="INFO"
fi

strip_ansi() { sed 's/\x1b\[[0-9;]*m//g'; }
v() { [[ -z "$1" || "$1" == "n/a" ]] && printf "%s%s%s" "$C_NA" "n/a" "$C_RST" \
                                    || printf "%s%s%s" "$C_OK" "$1" "$C_RST"; }

make_box_open() {
  # usage: make_box_open outvar "TITLE" "Label1" "Value1" ...
  local __out="$1" title="$2"; shift 2
  local rows=()
  rows+=("${C_TITLE}${title}${C_RST}")
  rows+=("$(printf "%s" "" )")  # Platzhalter für Trennlinie

  while [[ $# -gt 1 ]]; do
    local label="$1" value="$2"; shift 2
    rows+=("$C_KEY$label$C_RST = $(v "$value")")
  done

  # Breite anhand der längsten Plain-Zeile bestimmen
  local w=0 plain lines=()
  for r in "${rows[@]}"; do
    plain="$(echo -n "$r" | strip_ansi)"
    lines+=("$r")
    (( ${#plain} > w )) && w=${#plain}
  done
  (( w < 40 )) && w=40

  # Top-/Mid-/Bottom-Linien (nur horizontal, beidseitig offen)
  local top="$(printf "%0.s$H" $(seq 1 $w))"
  local mid="$(printf "%0.s$SEP" $(seq 1 $w))"
  local bot="$top"

  # Ausgabezeilen bauen (keine führenden/abschließenden Spaces)
  local out=()
  out+=("$top")
  out+=("${lines[0]}")     # Title
  out+=("$mid")
  for ((i=2;i<${#lines[@]};i++)); do out+=("${lines[$i]}"); done
  out+=("$bot")
  eval "$__out=(\"\${out[@]}\")"
}

# --- Boxen -------------------------------------------------------------------
make_box_open BOX4  "$ICON_V4  [V4]" \
  "Private IP"      "$ip4i" \
  "Oeffentliche IP" "$ip4e"

make_box_open BOX6  "$ICON_V6  [V6]" \
  "Private IP"      "$ip6i" \
  "Oeffentliche IP" "$ip6e"

make_box_open BOXI "$ICON_INFO  [Info]" \
  "Hostname"   "$HOST" \
  "Interface"  "$DEF_IF" \
  "MAC"        "$MAC" \
  "Gateway v4" "$GW4" \
  "Gateway v6" "$GW6" \
  "DNS"        "$DNS" \
  ${SSID:+ "SSID" "$SSID"}

# --- Ausgabe -----------------------------------------------------------------
for l in "${BOX4[@]}"; do printf "%s\n" "$l"; done
echo
for l in "${BOX6[@]}"; do printf "%s\n" "$l"; done
echo
for l in "${BOXI[@]}"; do printf "%s\n" "$l"; done
