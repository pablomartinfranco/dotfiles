#!/bin/bash

# ================================
# GPG Backup with On-the-Fly Compression & Encryption
# ================================

# === CONFIGURATION ===
# USB_MOUNT_PATH="/media/$USER/USB"   # Change to your USB path
USB_MOUNT_PATH="./"
KEY_ID=""                           # Leave empty to export all keys, or set KEY_ID="ABCDEF123456..."

DATESTAMP=$(date +%Y-%m-%d)
BACKUP_NAME="GPG-Backup-$DATESTAMP"
OUTPUT_FILE="$USB_MOUNT_PATH/${BACKUP_NAME}.tar.gz.gpg"

# === Sanity check ===
if [ ! -d "$USB_MOUNT_PATH" ]; then
    echo "❌ USB mount not found: $USB_MOUNT_PATH"
    exit 1
fi

echo "📦 Starting streaming export of GPG key bundle..."

# === Create TAR archive with everything via pipes ===
# All files are created on the fly using process substitution

tar -czf - -C /dev/stdin . > /dev/null # Dummy call to validate `tar` with pipes

tar -czf - \
    --transform="s:^:/$BACKUP_NAME/:" \
    <( 
        echo "🔐 Exporting private keys..." >&2
        if [ -z "$KEY_ID" ]; then
            gpg --export-secret-keys --armor
        else
            gpg --export-secret-keys --armor "$KEY_ID"
        fi
    )\
    --transform="s:.*:private-keys.asc:" \
    <( 
        echo "📤 Exporting public keys..." >&2
        if [ -z "$KEY_ID" ]; then
            gpg --export --armor
        else
            gpg --export --armor "$KEY_ID"
        fi
    )\
    --transform="s:.*:public-keys.asc:" \
    <(
        echo "🔒 Exporting ownertrust..." >&2
        gpg --export-ownertrust
    )\
    --transform="s:.*:ownertrust.txt:" \
    <(
        if [ -n "$KEY_ID" ]; then
            echo "🧨 Generating revocation certificate..." >&2
            gpg --gen-revoke "$KEY_ID"
        fi
    )\
    --transform="s:.*:revoke-cert.asc:" \
    | tee >(sha256sum > "$USB_MOUNT_PATH/${BACKUP_NAME}_SHA256.txt") \
    | gpg -c --cipher-algo AES256 -o "$OUTPUT_FILE"

echo "✅ Backup complete: $OUTPUT_FILE"
echo "📄 Checksums saved to: ${BACKUP_NAME}_SHA256.txt"
# echo "💡 To decrypt: gpg -o backup.tar.gz -d ${BACKUP_NAME}.tar.gz.gpg"
echo "💡 To restore: gpg -d ${BACKUP_NAME}.tar.gz.gpg | tar xz"
