#!/bin/bash

# ==========================
# GPG Cold Storage Backup Script (Encrypted + Compressed)
# ==========================

# === CONFIGURATION ===
# USB_MOUNT_PATH="/media/$USER/USB"  # Change this if needed
USB_MOUNT_PATH="./"
KEY_ID=""  # Leave empty to export all secret keys, or set your key ID
BACKUP_NAME="GPG-Backup-$(date +%Y-%m-%d)"
TMP_DIR=$(mktemp -d)

# === SANITY CHECK ===
if [ ! -d "$USB_MOUNT_PATH" ]; then
    echo "❌ USB mount not found: $USB_MOUNT_PATH"
    exit 1
fi

echo "📦 Creating temporary backup folder: $TMP_DIR/$BACKUP_NAME"
mkdir -p "$TMP_DIR/$BACKUP_NAME" || exit 1

# === EXPORT PRIVATE KEYS ===
echo "🔐 Exporting private keys..."
if [ -z "$KEY_ID" ]; then
    gpg --export-secret-keys --armor > "$TMP_DIR/$BACKUP_NAME/private-keys.asc"
else
    gpg --export-secret-keys --armor "$KEY_ID" > "$TMP_DIR/$BACKUP_NAME/private-keys.asc"
fi

# === EXPORT PUBLIC KEYS ===
echo "📤 Exporting public keys..."
if [ -z "$KEY_ID" ]; then
    gpg --export --armor > "$TMP_DIR/$BACKUP_NAME/public-keys.asc"
else
    gpg --export --armor "$KEY_ID" > "$TMP_DIR/$BACKUP_NAME/public-keys.asc"
fi

# === EXPORT REVOKE CERT ===
if [ -n "$KEY_ID" ]; then
    echo "🧨 Generating revocation certificate..."
    gpg --output "$TMP_DIR/$BACKUP_NAME/revoke-cert.asc" --gen-revoke "$KEY_ID"
else
    echo "⚠️  Skipping revocation certificate — KEY_ID not set"
fi

# === EXPORT OWNERTRUST ===
echo "🔒 Exporting ownertrust..."
gpg --export-ownertrust > "$TMP_DIR/$BACKUP_NAME/ownertrust.txt"

# === CREATE CHECKSUMS ===
echo "🧾 Creating SHA256 checksums..."
cd "$TMP_DIR/$BACKUP_NAME" || exit 1
sha256sum * > SHA256SUMS.txt
cd - > /dev/null

# === ENCRYPT + COMPRESS ===
OUTPUT_FILE="$USB_MOUNT_PATH/${BACKUP_NAME}.tar.gz.gpg"
echo "🔐 Compressing and encrypting backup to: $OUTPUT_FILE"
tar -C "$TMP_DIR" -cz "$BACKUP_NAME" | gpg -c --cipher-algo AES256 -o "$OUTPUT_FILE"

# === CLEANUP ===
echo "🧹 Cleaning up temporary files..."
rm -rf "$TMP_DIR"

echo "✅ Backup complete: $OUTPUT_FILE"
echo "📄 Checksums saved to: SHA256SUMS.txt"
# echo "💡 To decrypt later: gpg -o backup.tar.gz -d ${BACKUP_NAME}.tar.gz.gpg"
echo "💡 To restore: gpg -d ${BACKUP_NAME}.tar.gz.gpg | tar xz"
