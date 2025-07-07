#!/usr/bin/env bash

header_info() {
  clear
  cat <<"EOF"
PVE unLID script
EOF
}

RD=$(echo "\033[01;31m")
YW=$(echo "\033[33m")
GN=$(echo "\033[1;92m")
CL=$(echo "\033[m")
BFR="\\r\\033[K"
HOLD="-"
CM="${GN}✓${CL}"
CROSS="${RD}✗${CL}"

set -euo pipefail
shopt -s inherit_errexit nullglob

msg_info() {
  local msg="$1"
  echo -ne " ${HOLD} ${YW}${msg}..."
}

msg_ok() {
  local msg="$1"
  echo -e "${BFR} ${CM} ${GN}${msg}${CL}"
}

msg_error() {
  local msg="$1"
  echo -e "${BFR} ${CROSS} ${RD}${msg}${CL}"
}

start_routines() {
  header_info
  sed -i '$a HandleLidSwitch=ignore' /etc/systemd/logind.conf
  sed -i '$a HandleLidSwitchExternalPower=ignore' /etc/systemd/logind.conf
  sed -i '$a HandleLidSwitchDocked=ignore' /etc/systemd/logind.conf
  sed -i '$a LidSwitchIgnoreInhibited=no' /etc/systemd/logind.conf
}

# header_info
echo -e "\nThis script will Perform unLID script.\n"
while true; do
  read -p "Start the Proxmox unLID Script (y/n)?" yn
  case $yn in
  [Yy]*) break ;;
  [Nn]*)
    clear
    exit
    ;;
  *) echo "Please answer yes or no." ;;
  esac
done

if ! pveversion | grep -Eq "pve-manager/8\.[0-4](\.[0-9]+)*"; then
  msg_error "This version of Proxmox Virtual Environment is not supported"
  echo -e "Requires Proxmox Virtual Environment Version 8.0 or later."
  echo -e "Exiting..."
  sleep 2
  exit
fi

start_routines
