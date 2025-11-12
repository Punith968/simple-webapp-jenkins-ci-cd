#!/usr/bin/env bash
# validate.sh — check required files exist before build/deploy
# Exits with non-zero status if any required file is missing

set -euo pipefail

REQUIRED=(index.html styles.css script.js)
MISSING=()

for f in "${REQUIRED[@]}"; do
  if [ ! -f "$f" ]; then
    MISSING+=("$f")
  fi
done

if [ ${#MISSING[@]} -ne 0 ]; then
  echo "Missing required files:" >&2
  for m in "${MISSING[@]}"; do echo " - $m" >&2; done
  exit 2
else
  echo "All required files present: ${REQUIRED[*]}"
fi
