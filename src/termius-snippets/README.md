# Termius Snippets

This folder contains YAML snippet files for generating secure secrets in Termius.

## Summary of Features Across Versions

| Version                                         | Features                                                                                                                                            | Complexity |
| ----------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------- | ---------- |
| [Basic](snippet_v1_basic.yml)                   | Generation of basic secrets using hexadecimal values with options to configure key length.                                                          | O(1)       |
| [Stored](snippet_v2_store_env.yml)              | Storage of the secret in a file and as an environment variable.                                                                                     | O(1)       |
| [Encrypted](snippet_v3_encrypt_autodelete.yml)  | Encryption using GPG (AES256 by default), with the option to auto-delete the secret after use.                                                      | O(n)       |
| [Persistent](snippet_v4_persistent_logging.yml) | Option to encrypt the file via GPG, log details, provides persistence across sessions, and auto-deletes it from the session.                        | O(n)       |
| [Advanced](snippet_v5_webhook_hmac.yml)         | Demonstrates advanced usage such as securely sending metadata to a Webhook with HMAC-SHA256 signing, retrying on failure a limited number of times. | O(n)       |

---

## Importing Snippets

1. Open Termius
2. Go to `Settings` > `Snippets`
3. Click `Import Snippets`
4. Select the `.yml` file you want to import

---

## Script Files

The script files have been moved to the `scripts` folder for better organization.
