#!/bin/bash

# Get DateTime in UTC
YYYY=$(date -u +"%Y")
MM=$(date -u +"%m")
DD=$(date -u +"%d")
HH=$(date -u +"%H")
MI=$(date -u +"%M")
SS=$(date -u +"%S")

# Format the timestamp
timestamp="${YYYY}${MM}${DD}.${HH}${MI}${SS}"

# Ask for migration name
read -p "Enter the name of the migration (without spaces): " migration_name

# Validate that the name does not have spaces
if [[ "$migration_name" =~ \\  ]]; then
    echo "The migration name cannot contain spaces."
    exit 1
fi

# Create subfolders if they do not exist
mkdir -p migrations
mkdir -p migrations-undo

# Format the file names
filename="V${timestamp}__${migration_name}"
migrations_undo="U${timestamp}__${migration_name}"

# Create the files
touch "migrations/${filename}.sql"
touch "migrations-undo/${migrations_undo}.sql"

# Output the created files
echo "Files created:"
echo "migrations/${filename}.sql"
echo "migrations-undo/${migrations_undo}.sql"
