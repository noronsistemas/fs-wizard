#!/bin/bash

IMG="$1"
MNT_DIR="/mnt/fswizard"

if [[ -z "$IMG" ]]; then
    echo "Uso: $0 imagen.img"
    exit 1
fi

sudo mkdir -p "$MNT_DIR"
sudo mount -o loop,ro "$IMG" "$MNT_DIR"

echo "[+] Imagen montada en $MNT_DIR"

