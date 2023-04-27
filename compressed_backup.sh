#!/bin/bash

# Backup Script with Compression
# Author: TIF

# Prompt for source directory
read -rp "Enter the source directory to backup: " SOURCE_DIR

# Check if the source directory exists
if [ ! -d "$SOURCE_DIR" ]; then
  echo "Error: Source directory does not exist."
  exit 1
fi

# Prompt for destination directory
read -rp "Enter the backup destination directory: " DEST_DIR

# Check if the destination directory exists, if not create it
if [ ! -d "$DEST_DIR" ]; then
  mkdir -p "$DEST_DIR"
fi

# Create a timestamp for the backup file
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

# Create backup file name
BACKUP_FILE="${DEST_DIR}/backup_${TIMESTAMP}.tar.gz"

# Compress and create the backup file, suppressing the leading-slash warning
tar czf "${BACKUP_FILE}" "${SOURCE_DIR}" 2>/dev/null

# Check if the backup file was created successfully
if [ -f "${BACKUP_FILE}" ]; then
  echo "Backup successfully created at: ${BACKUP_FILE}"
else
  echo "Error: Backup creation failed."
  exit 1
fi

