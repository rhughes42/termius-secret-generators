#!/bin/bash
# Created by Graph Technologies (https://graphconsult.xyz || https://graphtechnologies.xyz)
# Consultancy and solution specialist based in Copenhagen, Denmark.
# Contact details can be found on our website.
# Provided as-is under the MIT license without any responsibility for its use or damage caused by its use.

# Calculates the elapsed time for a section of code.
print_elapsed_time() {
    local section="$1"
    local s_time="$2"
	local log_file="$3"
	local current_file="$4"

    local e_time=$(date +%s%3N)

	# Calculates the time difference in milliseconds.
    s_time=$(date -d @$((s_time / 1000)) +%s%3N)
    local message="[$section] → Execution time: $((e_time - s_time)) milliseconds"
    echo "$message"

    # Log the execution time if a log file is specified.
    if [ -n "$log_file" ]; then
        echo "Section [$section] completed at $(date '+%d-%m-%Y %-I:%M%P')" >> "$log_file"
    fi
}

# Function to check if a key in a dictionary is set.
check_dict_key() {
    local -n dict="$1" # Get the dictionary by reference.
    local key="$2" # Get the key.
    local value="${dict[$key]}" # Get the value from the dictionary.

    if [ -z "$value" ]; then # Check if the value is empty and set it to 'null' if it is.
        dict[$key]="null"
        return -1
    else
        if [[ "$value" =~ ^[0-9]+$ ]]; then # Check if the value is a number and keep it as is.
            dict[$key]=$value
            return 0
        elif [[ "$value" =~ ^(yes|Yes|YES|y|Y)$ ]]; then
            dict[$key]=1
            return 0
        elif [[ "$value" =~ ^(no|No|NO|n|N)$ ]]; then
            dict[$key]=0
            return 0
        elif [[ "$value" =~ ^[a-zA-Z0-9]+$ ]]; then # Check if the value is alphanumeric and keep it as is.
            dict[$key]=$value
            return 0
        else
            dict[$key]="null"
            return -1
        fi
    fi
}

# Get the current timestamp in the desired format.
get_timestamp() {
	date '+%d-%m-%Y %-I:%M%P' # Get the current timestamp in the desired format.
}

# Securely delete a file depending on the available command.
secure_delete() {
    local file="$1" # Get the file to be securely deleted.
    if command -v shred > /dev/null 2>&1; then # Check if shred is available.
        shred -u "$file"
    elif command -v srm > /dev/null 2>&1; then # Check if srm is available.
        srm -v "$file"
    else
        rm -P "$file" # Fallback to rm.
    fi
}

# Securely delete a file depending on the available command.
sanitize_environment() {
	local sanitize_vars="$1"
	local sanitize_files="$2"

    if command -v shred > /dev/null 2>&1; then # Check if shred is available.
        echo "Shredding any remaining data..."
		unset "${sanitize_vars[@]}"
		shred -u "${sanitize_files[@]}"
    elif command -v srm > /dev/null 2>&1; then # Check if srm is available.
        echo "Shredding any remaining data..."
        unset "${sanitize_vars[@]}"
        srm -v "${sanitize_files[@]}"
    else
        echo "Removing data securely..."
        unset "${sanitize_vars[@]}"
        rm -P "${sanitize_files[@]}"
    fi
}

# Function to send the secret to the webhook.
send_to_webhook() {
	local secret=$1
	local url=$2
	local hmac_secret=$3
	local retries=$4
	local delay=$5

	for ((i=0; i<retries; i++)); do
		timestamp=$(date +%s)
		signature=$(echo -n "$secret$timestamp" | openssl dgst -sha256 -hmac "$hmac_secret" | awk '{print $2}')
		response=$(curl -s -o /dev/null -w "%{http_code}" -X POST "$url" \
			-H "Content-Type: application/json" \
			-H "X-Hub-Signature: sha256=$signature" \
			-d "{\"secret\":\"$secret\", \"timestamp\":\"$timestamp\"}")

		if [ "$response" -eq 200 ]; then
			echo "Secret successfully sent to webhook."
			return 0
		else
			echo "Failed to send secret to webhook. Attempt $((i+1)) of $retries."
			sleep "$delay"
		fi
	done

	echo "Failed to send secret to webhook after $retries attempts."
	return 1
}