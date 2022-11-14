# Little Notes

A CRDT implementation using [Drew McCormak's](https://appdecentral.com) tutorials. Basically codable types with merge strategies. State is JSON encoded and saved to disk then compared to whatever's last sent to the cloud.

### Pros

- Pretty simple types, code is succinct 
- JSON is pretty readable, easy to pass to other languages

### Cons

- File size, no compression
- No history pruning