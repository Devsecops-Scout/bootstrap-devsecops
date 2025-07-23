#!/bin/bash
# Prevent large or risky files from being committed

MAX_SIZE=52428800  # 50MB
BLOCKED_EXTENSIONS=("zip" "jar" "exe" "tar.gz" "7z" "dmg" "msi")

echo "🔐 Secure Pre-Commit Hook Triggered"

FILES=$(git diff --cached --name-only)

for FILE in $FILES; do
  [ ! -f "$FILE" ] && continue

  EXT="${FILE##*.}"
  SIZE=$(stat -c%s "$FILE")

  if [ "$SIZE" -gt "$MAX_SIZE" ]; then
    echo "🚫 ERROR: '$FILE' exceeds 50MB. Use Git LFS or external storage."
    exit 1
  fi

  for EXT_BLOCK in "${BLOCKED_EXTENSIONS[@]}"; do
    if [[ "$EXT" == "$EXT_BLOCK" ]]; then
      echo "⚠️ ERROR: Risky file type '.$EXT' detected in '$FILE'. Commit blocked."
      exit 1
    fi
  done

  if git check-ignore -q "$FILE"; then
    echo "⚠️ ERROR: '$FILE' is listed in .gitignore. Remove from staging."
    echo "👉 Run: git rm --cached '$FILE'"
    exit 1
  fi
done

echo "✅ All secure checks passed."
exit 0
