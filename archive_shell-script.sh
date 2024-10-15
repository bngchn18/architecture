#!/bin/bash

if [ -z "$1" ]; then
  echo "Error: The input is not a folder"
  exit 1
fi

if [ -z "$2" ]; then
  echo "Error: The percent is not in input"
  exit 1
fi

if [ -z "$3" ]; then
  echo "Error: The count is not in input"
  exit 1
fi

TARGET_PATH="$1"
PERCENT="$2"
COUNT="$3"

cd "$TARGET_PATH"

if [ $? -ne 0 ]; then
  echo "Can't turn into $TARGET_PATH"
  exit 1
fi

USE_PERCENT=$(df -h . | awk 'NR==2 {print $(NF-1)}' | sed 's/%//')
echo "Folder usage: ${USE_PERCENT}%"

if [ "$USE_PERCENT" -gt "$PERCENT" ]; then
  echo "Archiving oldest files..."

  # Создание временной папки для архивации
  TEMP_DIR=$(mktemp -d /tmp/archive_limit.XXXXXX)

  # Поиск и архивирование старых файлов
  OLD_FILES=$(find . -type f -printf "%T@ %p\n" | sort -n | head -n "$COUNT" | cut -d' ' -f2-)

  if [ -n "$OLD_FILES" ]; then
    tar -czf "$TEMP_DIR/archive.tar.gz" $OLD_FILES
    echo "Archive created successfully in $TEMP_DIR!"
  else
    echo "No files to archive."
  fi
else
  echo "No archiving needed."
fi