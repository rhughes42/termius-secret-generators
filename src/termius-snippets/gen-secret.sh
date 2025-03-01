#!/bin/bash
# Created by Graph Technologies (https://graphconsult.xyz || https://graphtechnologies.xyz)
# Consultancy and solution specialist based in Copenhagen, Denmark.
# Contact details can be found on our website.
# Provided as-is under the MIT license without any responsibility for its use or damage caused by its use.

# Source the common functions and variables.
source ./scripts/common-functions.sh

LOG_FILE=~/.secret_log # If necessary, change this to a different path.
SCRIPT="gen-secret.sh"

# Declare an associative array to hold variables.
declare -A VARS=(
    ["length"]=""
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
SECRET=$(openssl rand -hex "${VARS["length"]}")
print_elapsed_time "Secret Generation" $start_secret_gen $LOG_FILE $SCRIPT

# Log the secret generation.
if [ -f "$LOG_FILE" ]; then
    echo "[$(get_timestamp)] Secret generated (length: {{length}}, encrypted: {{encrypt}})" >> "$LOG_FILE"
else
    touch "$LOG_FILE"
    echo "[$(get_timestamp)] Secret generated (length: {{length}}, encrypted: {{encrypt}})" > "$LOG_FILE"
    chmod 600 "$LOG_FILE"
fi

print_elapsed_time "Overall Runtime" $overall_start $LOG_FILE $SCRIPT

# Log the script completion.
if [ -n "$LOG_FILE" ]; then
    echo "Script completed successfully at $(date '+%d-%m-%Y %-I:%M%P')" >> "$LOG_FILE"
fi

echo "Script completed successfully."