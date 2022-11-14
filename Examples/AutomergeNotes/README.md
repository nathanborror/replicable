# Automerge Notes

A CRDT implementation using [Automerge](https://automerge.org). State is binary saved to disk then compared to whatever's last sent to the cloud.

### Pros

- Takes any codable types
- Small footprint when written to disk

### Cons

- Relies on a binary format
- No history pruning
- Kinda magical