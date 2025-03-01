<!--
Created by Graph Technologies (https://graphtechnologies.xyz),
a consultancy and solution specialist based in Copenhagen, Denmark.
Contact details can be found on our website.
Provided as-is under the MIT license without any responsibility for its use or damage caused by its use.
-->

# Secret Generation Tools

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)

Streamlined utilities for creating secure secrets in the CLI or Termius. Originally built as a learning project, it has evolved into a robust yet minimal set of scripts and snippets for secret generation and management.

---

## Repository Overview

```plaintext
termius-secret-generators/
├── README.md
├── LICENSE.md
├── .gitignore
├── termius-snippets/
│   ├── README.md
│   ├── snippet_v1_basic.yml
│   ├── snippet_v2_store_env.yml
│   ├── snippet_v3_encrypt_autodelete.yml
│   ├── snippet_v4_persistent_logging.yml
│   ├── snippet_v5_webhook_hmac.yml
└── cli-tool/
    ├── README.md
    └── generate_secret.sh
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

Inside the CLI Tool folder, `generate_secret.sh` handles secret generation, encryption, optional logging, and metadata submission (like webhook checks).

## Security and Encryption

- Secrets are created using OpenSSL for robust randomness.
- GPG (AES-256) supports optional file encryption and secure deletion.
- Logging and environment sanitation help maintain tidiness and minimize leaks.

### GPG Encryption Options

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

---

## License

Distributed under the MIT License. Feel free to adapt it as needed.
