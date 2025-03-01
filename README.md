<!--
Created by Graph Technologies (https://graphtechnologies.xyz),
a consultancy and solution specialist based in Copenhagen, Denmark.
Contact details can be found on our website.
Provided as-is under the MIT license without any responsibility for its use or damage caused by its use.
-->

# Secret Generation Tools

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)

Streamlined utilities for creating secure secrets in the CLI or Termius. Originally built as part of an online course, it has evolved into a robust yet minimal set of scripts and snippets for secret generation and management.

---

## Repository Overview

```plaintext
termius-secret-generators/
├── README.md
├── LICENSE.md
├── .gitignore
├── termius-snippets/
│   ├── README.md
│   ├── gen-and-log-persistent-secret.yml
│   ├── gen-and-transmit-secret.yml
│   ├── gen-encrypted-secret.yml
│   ├── gen-secret.yml
│   ├── gen-stored-secret.yml
│   └── scripts/
│       ├── common-functions.sh
│       ├── gen-and-log-persistent-secret.sh
│       ├── gen-and-transmit-secret.sh
│       ├── gen-encrypted-secret.sh
│       ├── gen-secret.sh
│       └── gen-stored-secret.sh
└── cli-tool/
    ├── README.md
    └── generate-secret.sh
```

## Getting Started

1. Clone the repository:
   ```bash
   git clone https://github.com/rhughes42/termius-secret-generators.git
   cd termius-secret-generators
   ```
2. Ensure you have OpenSSL (or OpenSSL Light) and GPG installed.

## Usage

Use the Termius snippets or run the CLI tool directly. Both approaches demonstrate multiple security workflows, from basic generation to encryption and logging.

## Termius Snippets

Check the Termius Snippets folder for each version’s instructions and incremental features.

## CLI Tool

Inside the CLI Tool folder, `generate-secret.sh` handles secret generation, encryption, optional logging, and metadata submission (like webhook checks).

## Security and Encryption

- Secrets are created using OpenSSL for robust randomness.
- GPG (AES-256) supports optional file encryption and secure deletion.
- Logging and environment sanitation help maintain tidiness and minimize leaks.

## GPG Encryption Options

- Symmetric AES-256 encryption.
- Securely remove unencrypted files after encryption.
- Automate or prompt-based interaction paths to suit different environments.

## Runtime Complexity

Most tasks run in constant time (O(1)). Repeated tasks (loops, retries) scale linearly. Overall overhead remains small due to efficient design.

## Security Considerations

- Keep secrets and keys secure.
- Be cautious with environment variables.
- Ensure logs don’t store sensitive data.
- Use strong encryption and safe key management.

## Contributing

Contributions are welcome. Fork, make changes, and submit a pull request.

## Learning Opportunities

- Explore secret generation with minimal dependencies.
- Gain insight into secure bash scripting, encryption, environment sanitization, and logging.
- Learn how to integrate GPG encryption and HMAC hashing in real-world scenarios.

## Additional Functions

### common-functions.sh

This script contains common utility functions used across various scripts in the project.

- **print_elapsed_time**: Calculates the elapsed time for a section of code.

  - Arguments:
    - $1 - Section name
    - $2 - Start time in milliseconds
    - $3 - Log file path (optional)
    - $4 - Current file name (optional)

- **check_dict_key**: Function to check if a key in a dictionary is set.

  - Arguments:
    - $1 - Dictionary (associative array) name
    - $2 - Key to check

- **get_timestamp**: Get the current timestamp in the desired format.

- **secure_delete**: Securely delete a file depending on the available command.

  - Arguments:
    - $1 - File path to be securely deleted

- **sanitize_environment**: Securely delete a file depending on the available command.

  - Arguments:
    - $1 - Array of variables to sanitize
    - $2 - Array of files to securely delete

- **send_to_webhook**: Function to send the secret to the webhook.
  - Arguments:
    - $1 - Secret to send
    - $2 - Webhook URL
    - $3 - HMAC secret for signing
    - $4 - Number of retries
    - $5 - Delay between retries

---

## License

Distributed under the MIT License. Feel free to adapt it as needed.
