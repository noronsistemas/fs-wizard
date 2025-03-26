#!/bin/bash

PARTICION="$1"

if [[ -z "$PARTICION" ]]; then
    echo "Uso: $0 /ruta/a/particion_o_imagen"
    exit 1
fi

echo "[+] Montando debugfs sobre: $PARTICION"

# Llamamos a debugfs con una sesión interactiva automatizada
debugfs "$PARTICION" <<EOF | tee /tmp/inode_list.txt
ls -p
EOF

echo
echo "[+] Lista de archivos con inodes:"
awk '/^[-dl]/ { print NR-1 ") " $0 }' /tmp/inode_list.txt | head -n 50

echo
read -p "[?] Ingresá el path completo del archivo a inspeccionar: " ARCHIVO

# Obtenemos el número de inode y el bloque asociado
debugfs "$PARTICION" <<EOF | tee /tmp/inode_info.txt
stat $ARCHIVO
EOF

INODE=$(grep 'Inode:' /tmp/inode_info.txt | awk '{print $2}')
BLOCK=$(grep -m1 'Block:' /tmp/inode_info.txt | sed 's/.*Block: //' | awk '{print $1}')

echo "[🔎] Inode: $INODE"
echo "[📦] Primer bloque: $BLOCK"

read -p "¿Querés ver el contenido crudo con hexdump? [s/N]: " RESP
if [[ "$RESP" == "s" || "$RESP" == "S" ]]; then
    dd if="$PARTICION" bs=4096 skip="$BLOCK" count=1 2>/dev/null | hexdump -C | less
fi

