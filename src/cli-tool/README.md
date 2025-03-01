<!--
Created by Graph Technologies (https://graphconsult.xyz || https://graphtechnologies.xyz),
a consultancy and solution specialist based in Copenhagen, Denmark.
Contact details can be found on our website.
Provided as-is under the MIT license without any responsibility for its use or damage caused by its use.
-->

# CLI Tool

This folder contains a **standalone shell script** (`generate_secret.sh`) for generating secure secrets. It supports:

- Secure random secret generation (OpenSSL)
- Optional GPG encryption (AES-256)
- Persistence of the secret across sessions
- Logging (local file + optional webhook)
- HMAC-SHA256 for webhook signing
- Retry mechanism for failed webhook requests

## Usage

#### Install Dependencies

If you are using the CLI tool, you need to install the following dependencies:

- OpenSSL
- GPG
- curl
- bash 4+

#### Modify Execution Permissions

```bash
chmod +x generate_secret.sh
```

#### Run the Script

```bash
./generate_secret.sh
```

#### Script Options

Answer the prompts: length, encryption, persistence, webhook info,

### Logging

Logs are stored in ~/.secret_log. Secrets in ~/.generated_secret (or ~/.generated_secret.gpg if encrypted).
