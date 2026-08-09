#!/usr/bin/env bash
set -euo pipefail

SRC="/home/juan/Escritorio/SKILLS"
DEST="$HOME/.config/opencode/skills"
mkdir -p "$DEST"

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

renovadas=0
nuevas=0
sin_cambios=0

while IFS= read -r md; do
  skill_dir="$(dirname "$md")"
  name="$(awk -F': ' '/^name:/{print $2; exit}' "$md")"
  [ -n "$name" ] || { echo "SKIP (sin name): $skill_dir"; continue; }

  rm -rf "$TMP/$name"
  cp -rT "$skill_dir" "$TMP/$name"

  if [ -d "$DEST/$name" ]; then
    if diff -rq "$TMP/$name" "$DEST/$name" >/dev/null 2>&1; then
      echo "sin cambios : $name"
      sin_cambios=$((sin_cambios + 1))
    else
      rm -rf "$DEST/$name"
      cp -rT "$TMP/$name" "$DEST/$name"
      echo "renovada    : $name"
      renovadas=$((renovadas + 1))
    fi
  else
    cp -rT "$TMP/$name" "$DEST/$name"
    echo "nueva       : $name"
    nuevas=$((nuevas + 1))
  fi
done < <(find "$SRC" -name SKILL.md | sort)

echo "-----------------------------"
echo "Resumen: $nuevas nueva(s), $renovadas renovada(s), $sin_cambios sin cambios"
ls "$DEST"