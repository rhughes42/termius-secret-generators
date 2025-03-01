# Runtime Estimates

Based on the provided table and the assumption of a moderately powerful data centre server with 1GB/s download and 500Mb/s upload, the estimated runtimes are:

- Basic (gen-secret.yml): ~1 millisecond
- Stored (gen-stored-secret.yml): ~2 milliseconds
- Encrypted (gen-encrypted-secret.yml): ~500 milliseconds
- Persistent (gen-and-log-persistent-secret.yml): ~700 milliseconds
- Advanced (gen-and-transmit-secret.yml): ~100 milliseconds

Note:
Network transfer times for the advanced snippet are negligible due to the high throughput available for the small payload.
