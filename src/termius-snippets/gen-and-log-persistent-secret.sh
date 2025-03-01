#!/bin/bash
# Created by Graph Technologies (https://graphconsult.xyz || https://graphtechnologies.xyz)
# Consultancy and solution specialist based in Copenhagen, Denmark.
# Contact details can be found on our website.
# Provided as-is under the MIT license without any responsibility for its use or damage caused by its use.

# Source the common functions and variables.
source ./scripts/common-functions.sh

LOG_FILE=~/.secret_log # If necessary, change this to a different path.
SCRIPT="gen-and-log-persistent-secret.sh"

# Declare an associative array to hold variables.
declare -A VARS=(
    ["length"]=""
    ["encrypt"]=""
    ["persist"]=""
    ["auto_delete"]=""
    ["seed"]=""
)

# Add timing function and start stopwatch
overall_start=$(date +%s%3N)

# Validate all variables.
start_validation=$(date +%s%3N)
for var in "${!VARS[@]}"; do
    if ! check_dict_key VARS "$var"; then
        echo "Variable '${var}' is not set or invalid."
        echo "Please set the variable '${var}' to a valid value."
        exit 1
    fi
done
print_elapsed_time "Variable Validation" $start_validation $LOG_FILE $SCRIPT

# Generate a random secret.
start_secret_gen=$(date +%s%3N)
if [ -z "${VARS["seed"]}" ]; then
    # Seed the random number generator with additional entropy from /dev/urandom.
    SECRET=$(openssl rand -hex "${VARS["length"]}")
else
    # Use the provided seed for deterministic results.
    SECRET=$(openssl rand -hex "${VARS["length"]}" -seed "${VARS["seed"]}")
fi
print_elapsed_time "Secret Generation" $start_secret_gen $LOG_FILE $SCRIP

echo "Generated Secret: $SECRET"
echo "$SECRET" > ~/.generated_secret
chmod 600 ~/.generated_secret

# Persist the secret in ~/.bashrc and ~/.zshrc if requested.
if [ "${VARS["persist"]}" = 1 ]; then
    persist_start=$(date +%s%3N)

    echo "export SECRET=\"$SECRET\"" >> ~/.bashrc
    echo "export SECRET=\"$SECRET\"" >> ~/.zshrc
    echo "Secret added to ~/.bashrc and ~/.zshrc"

    persist_end=$(date +%s%3N)
    print_elapsed_time "Persistence" $persist_start $LOG_FILE $SCRIPT
fi

# Encrypt the secret if requested.
if [ "${VARS["encrypt"]}" = 1 ]; then
    encryption_start=$(date +%s%3N)
    echo "Encrypting the secret..."

    gpg --batch --yes --symmetric --cipher-algo AES256 ~/.generated_secret
    echo "Securely deleting the original secret file..."

    start_delete_secret=$(date +%s%3N)
	secure_delete "~/.generated_secret"
	print_elapsed_time "Secret Deletion" $start_delete_secret $LOG_FILE $SCRIPT

    echo "Secret encrypted to ~/.generated_secret.gpg"
    encryption_end=$(date +%s%3N)

    print_elapsed_time "Encryption" $encryption_start $LOG_FILE $SCRIPT
else
    encryption_start=$(date +%s%3N)
    echo "Secret not encrypted, securely deleting the original secret file..."

    start_delete_secret=$(date +%s%3N)
	secure_delete "~/.generated_secret"
	print_elapsed_time "Secret Deletion" $start_delete_secret $LOG_FILE $SCRIPT

    print_elapsed_time "Non-Encryption Operation" $encryption_start $LOG_FILE $SCRIPT
fi

# Log the secret generation.
if [ -f "$LOG_FILE" ]; then # Check if the log file exists.
    echo "[$(get_timestamp)] Secret generated (length: ${VARS["length"]}, encrypted: ${VARS["encrypt"]}, persisted: ${VARS["persist"]})" >> "$LOG_FILE"
else # If the log file does not exist, create it.
    touch "$LOG_FILE"
    echo "[$(get_timestamp)] Secret generated (length: ${VARS["length"]}, encrypted: ${VARS["encrypt"]}, persisted: ${VARS["persist"]})" > "$LOG_FILE"

    chmod 600 "$LOG_FILE"
fi

# Optionally, time the sanitization stage if it is executed.
if [ "${VARS["sanitize"]}" = 1 ]; then
    sanitize_start=$(date +%s%3N)
    echo "Sanitizing the environment..."

    sanitize=("VAR" "VARS" "SECRET")
    sanitize_files=("$LOG_FILE" "~/.generated_secret")

    start_sanitize=$(date +%s%3N)
    sanitize_environment sanitize sanitize_files

    # Unset all variables.
	for var in "${sanitize[@]}"; do
		unset "$var"
	done

    echo "Environment sanitized."
    print_elapsed_time "Sanitization" $sanitize_start $LOG_FILE $SCRIPT
fi

print_elapsed_time "Overall Runtime" $overall_start $LOG_FILE $SCRIPT

# Log the script completion.
if [ -n "$LOG_FILE" ]; then
    echo "Script completed successfully at $(date '+%d-%m-%Y %-I:%M%P')" >> "$LOG_FILE"
fi

echo "Script completed successfully."
