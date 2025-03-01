#!/bin/bash
# Created by Graph Technologies (https://graphconsult.xyz || https://graphtechnologies.xyz)
# Consultancy and solution specialist based in Copenhagen, Denmark.
# Contact details can be found on our website.
# Provided as-is under the MIT license without any responsibility for its use or damage caused by its use.

# CLI Tool: generate_secret.sh
# -----------------------------
# Features:
# - Secure random secret generation (OpenSSL)
# - Optional GPG encryption (AES-256)
# - Environment variable export
# - Persistence across shell sessions
# - Metadata logging
# - Webhook integration with HMAC-SHA256 signing
# - Retry mechanism for failed webhooks
# - Auto-delete option

# Source the common functions and variables.
source ./common-functions.sh\

LOG_FILE=~/.secret_log # If necessary, change this to a different path.
SCRIPT="gen-and-transmit-secret.sh"

MAX_RETRIES=3
RETRY_DELAY=5

# Prompt for user inputs
read -p "Enter secret length (8-64): " LENGTH
read -p "Encrypt secret with GPG? (yes/no): " ENCRYPT
read -p "Persist secret across sessions? (yes/no): " PERSIST
read -p "Auto-delete after export? (yes/no): " AUTO_DELETE
read -p "Send metadata to Webhook? (yes/no): " SEND_WEBHOOK

# Prompt for webhook details if needed`.`
if [ "$SEND_WEBHOOK" = "yes" ]; then
  read -p "Enter Webhook URL: " WEBHOOK_URL
  read -p "Enter HMAC secret: " HMAC_SECRET
fi

# Validate inputs.
if ! [[ "$LENGTH" =~ ^[8-9]|[1-5][0-9]|6[0-4]$ ]]; then
  echo "Invalid length. Please enter a number between 8 and 64."
  exit 1
fi

# Generate secret
SECRET=$(openssl rand -hex "$LENGTH")
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

echo "Generated Secret: $SECRET"
echo "$SECRET" > "$HOME/.generated_secret"
chmod 600 "$HOME/.generated_secret"

# Encrypt if needed
if [ "$ENCRYPT" = "yes" ]; then
  gpg --batch --yes --symmetric --cipher-algo AES256 "$HOME/.generated_secret"
  shred -u "$HOME/.generated_secret"
  echo "Secret encrypted and stored as $HOME/.generated_secret.gpg"
fi

# Export to environment
export SECRET="$SECRET"
echo "Secret stored as environment variable \$SECRET"

# Persist across sessions
if [ "$PERSIST" = "yes" ]; then
  echo "export SECRET=\"$SECRET\"" >> "$HOME/.bashrc"
  echo "export SECRET=\"$SECRET\"" >> "$HOME/.zshrc"
  echo "Secret added to ~/.bashrc and ~/.zshrc"
fi

# Log metadata
echo "[$TIMESTAMP] Secret generated (length: $LENGTH, encrypted: $ENCRYPT, persisted: $PERSIST)" >> "$LOG_FILE"
chmod 600 "$LOG_FILE"

# Webhook integration with HMAC
if [ "$SEND_WEBHOOK" = "yes" ]; then
  PAYLOAD="{\"timestamp\": \"$TIMESTAMP\", \"length\": \"$LENGTH\", \"encrypted\": \"$ENCRYPT\", \"persisted\": \"$PERSIST\"}"
  SIGNATURE=$(echo -n "$PAYLOAD" | openssl dgst -sha256 -hmac "$HMAC_SECRET" | awk '{print $2}')

  ATTEMPT=0
  while [ $ATTEMPT -lt $MAX_RETRIES ]; do
    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" \
      -X POST \
      -H "Content-Type: application/json" \
      -H "X-Signature: $SIGNATURE" \
      -d "$PAYLOAD" "$WEBHOOK_URL")

    if [ "$RESPONSE" -eq 200 ]; then
      echo "Webhook sent successfully."
      break
    else
      echo "Webhook failed (attempt $((ATTEMPT+1))/$MAX_RETRIES), retrying in $RETRY_DELAY seconds..."
      sleep $RETRY_DELAY
      ((ATTEMPT++))
    fi
  done

  if [ $ATTEMPT -eq $MAX_RETRIES ]; then
    echo "Webhook failed after $MAX_RETRIES retries. Logging failure."
    echo "[$TIMESTAMP] Webhook failed after $MAX_RETRIES retries" >> "$LOG_FILE"
  fi
fi

# Auto-delete if enabled
if [ "$AUTO_DELETE" = "yes" ]; then
  if [ "$ENCRYPT" = "yes" ]; then
    shred -u "$HOME/.generated_secret.gpg"
  fi
  unset SECRET
  echo "Secret deleted from disk and unset from session."
fi