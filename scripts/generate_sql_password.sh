#!/bin/bash

# Set password length
PASSWORD_LENGTH=16

# Generate a secure random password
PASSWORD=$(tr -dc 'A-Za-z0-9@#%^&*' < /dev/urandom | head -c $PASSWORD_LENGTH)

# File to store the password securely
PASSWORD_FILE=~/secure_sql_password.txt

# Save the password to the file
echo "$PASSWORD" > "$PASSWORD_FILE"

# Set permissions so only you can read/write
chmod 600 "$PASSWORD_FILE"

# Export as environment variable (optional)
export SQL_PASSWORD="$PASSWORD"

# Create a masked version for logging
MASKED_PASSWORD="*******${PASSWORD: -4}" # Show only last 4 characters

# Output for user (safe)
echo "✅ SQL password generated and stored securely."
echo "🔒 Masked password: $MASKED_PASSWORD"
echo "📂 Password file: $PASSWORD_FILE"

# Instructions for user
echo ""
echo "⚡ To load the password later, run:"
echo "   export SQL_PASSWORD=\$(cat $PASSWORD_FILE)"
