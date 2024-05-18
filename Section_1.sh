#!/bin/bash

# Check whether the number of argument is provided correctly
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 SOURCE_DIR BACKUP_DIR"
  exit 1
fi

SOURCE_DIR=$1
BACKUP_DIR=$2

# Check if the source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
  echo "Error: Source directory '$SOURCE_DIR' does not exist."
  exit 1
fi

# Check if the backup directory exists, if not create it
if [ ! -d "$BACKUP_DIR" ]; then
  echo "Backup directory '$BACKUP_DIR' does not exist. Creating it..."
  mkdir -p "$BACKUP_DIR"
  if [ $? -ne 0 ]; then
    echo "Error: Failed to create backup directory '$BACKUP_DIR'."
    exit 1
  fi
fi

# appends the current date to the backup file name
DATE=$(date +%Y%m%d)
BACKUP_FILENAME="backup_$(basename $SOURCE_DIR)_$DATE.tar.gz"

# Create the backup and compress it
tar -czf "$BACKUP_FILENAME" -C "$SOURCE_DIR" .
if [ $? -ne 0 ]; then
  echo "Error: Failed to create the backup archive."
  exit 1
fi

# Move the backup file to the backup directory
mv "$BACKUP_FILENAME" "$BACKUP_DIR/"
if [ $? -ne 0 ]; then
  echo "Error: Failed to move the backup file to '$BACKUP_DIR'."
  exit 1
fi

echo "Backup successful! File saved to '$BACKUP_DIR/$BACKUP_FILENAME'."
