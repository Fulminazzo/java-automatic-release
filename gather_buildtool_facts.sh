#!/usr/bin/env bash

echo "Environment Variables:"
echo "$BUILD_FILE"
echo "$MODULES_FILE"
echo "$MODULES_ID"
echo "$OUTPUT_DIR"
echo "$VERSION_REGEX"
echo "$MODULES_REGEX"

if grep -q "version" "$BUILD_FILE"; then
  # Get only one occurrence of version by converting it into array
  # shellcheck disable=SC2207
  tmp=($(grep -Po "$VERSION_REGEX" "$BUILD_FILE"))
  version=${tmp[0]}
else
  exit 0
fi

if grep -q "$MODULES_ID" "$MODULES_FILE"; then
  subprojects=$(grep -Po "$MODULES_REGEX" "$MODULES_FILE")
else
  subprojects=""
fi

files="$OUTPUT_DIR$REPOSITORY_NAME-$version.jar"
if ! [ -f "$files" ]; then
  files=""
fi

for sub in $subprojects; do
  file="$sub/$OUTPUT_DIR"
  if [ -d "$file" ]; then
    files="$files $(ls "$file"*-"$version".jar)"
  fi
done

echo "Found version: \"$version\""
echo "Found files: \"$files\""

echo VERSION="$version" >> $GITHUB_OUTPUT
echo FILES="$files" >> $GITHUB_OUTPUT