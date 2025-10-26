#!/usr/bin/env bash
# Download all public Cohere fonts into the current directory

set -euo pipefail

BASE_URL="https://fonts.cohere.com"
INDEX_URL="$BASE_URL/"
TMPFILE="$(mktemp)"

echo "Fetching font list from $INDEX_URL ..."
wget -q -O "$TMPFILE" "$INDEX_URL"

# Extract <Key> entries and download each
grep -oP '(?<=<Key>).*?(?=</Key>)' "$TMPFILE" | while read -r key; do
  echo "Downloading $key ..."
  wget -q --show-progress "$BASE_URL/$key" -O "$(basename "$key")"
done

echo "✅ All fonts downloaded to $(pwd)"

rm "$TMPFILE"
