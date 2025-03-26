#!/bin/bash

DIARIO="$HOME/.nacimientos_digitales.log"
ARCHIVO="$1"

if [[ -z "$ARCHIVO" ]]; then
    echo "Uso: $0 nombre_del_archivo"
    exit 1
fi

touch "$ARCHIVO"
INFO=$(stat --format="Nombre: %n | Inode: %i | Nacimiento: %w" "$ARCHIVO")

[[ "$INFO" == *"Birth: -" ]] && INFO=$(stat --format="Nombre: %n | Inode: %i | Nacimiento (approx): %y" "$ARCHIVO")

echo "$INFO" >> "$DIARIO"
echo "🍼 $INFO"

