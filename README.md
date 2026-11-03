# Zenc Protocol

Protocol definitions and message schemas for the Zenc livestreaming ecosystem.

## Overview

This module provides Protocol Buffer definitions for all messages exchanged between Zenc components:
- **zenc-server** (Go)
- **zenc-sdk** (TypeScript/JavaScript)
- **zenc-sdk-go** (Go)
- Other services (Python, etc.)

## Features

- ✅ Protocol Buffer 3 definitions
- ✅ Code generation for Go, TypeScript, Python
- ✅ Versioned message schemas
- ✅ Comprehensive error codes
- ✅ WebSocket signaling messages
- ✅ REST API messages

## Installation

### Prerequisites

```bash
# Install protoc (Protocol Buffer compiler)
# macOS
brew install protobuf

# Ubuntu/Debian
sudo apt-get install protobuf-compiler

# Verify installation
protoc --version
```

### Install Code Generators

```bash
# For Go
make install-deps
# or manually:
go install google.golang.org/protobuf/cmd/protoc-gen-go@latest

# For TypeScript
npm install -g ts-proto

# Python works with just protoc
```

## Usage

### Generate All Languages

```bash
make generate
```

### Generate Specific Language

```bash
# Go only
make generate-go

# TypeScript only
make generate-ts

# Python only
make generate-python
```

### Using in Go

```go
import (
    pb "github.com/cyper98/zenc-protocol/go/protocol"
)

// Create a join room request
req := &pb.JoinRoomRequest{
    RoomId: "room-123",
    UserId: "user-456",
    Role:   pb.RoomRole_ROOM_ROLE_PUBLISHER,
}
```

### Using in TypeScript

```typescript
import { JoinRoomRequest, RoomRole } from './generated/typescript/room';

const req: JoinRoomRequest = {
    roomId: 'room-123',
    userId: 'user-456',
    role: RoomRole.ROOM_ROLE_PUBLISHER,
};
```

## Message Types

### Common Types (`common.proto`)
- Enums: `RoomRole`, `TrackKind`, `TrackSource`, `TrackStatus`, `ConnectionState`, `ConnectionQuality`, `QualityLevel`, `ErrorCode`
- Messages: `Error`, `Timestamp`

### Room Messages (`room.proto`)
- `Room` - Room information
- `CreateRoomRequest/Response` - Create new room
- `GetRoomRequest/Response` - Get room info
- `ListRoomsRequest/Response` - List all rooms
- `JoinRoomRequest/Response` - Join a room
- `LeaveRoomRequest/Response` - Leave a room
- `RoomEvent` - Room state changes

### Participant Messages (`participant.proto`)
- `Participant` - Participant information
- `ListParticipantsRequest/Response` - List participants
- `GetParticipantRequest/Response` - Get participant info
- `UpdateParticipantRequest/Response` - Update participant
- `ParticipantEvent` - Participant state changes

### Track Messages (`track.proto`)
- `Track` - Track information
- `PublishTrackRequest/Response` - Publish a track
- `UnpublishTrackRequest/Response` - Unpublish a track
- `SubscribeTrackRequest/Response` - Subscribe to track
- `UnsubscribeTrackRequest/Response` - Unsubscribe from track
- `HoldTrackRequest/Response` - Pause track
- `ResumeTrackRequest/Response` - Resume track
- `ICECandidate` - WebRTC ICE candidate
- `TrackEvent` - Track state changes

### Signaling Messages (`signaling.proto`)
- `SignalingMessage` - WebSocket message wrapper
- `PingRequest/PongResponse` - Keep-alive

## Project Structure

```
zenc-protocol/
├── proto/                  # Protocol Buffer definitions
│   ├── common.proto       # Common types and enums
│   ├── room.proto         # Room messages
│   ├── participant.proto  # Participant messages
│   ├── track.proto        # Track messages
│   └── signaling.proto    # WebSocket messages
├── generated/             # Generated code (gitignored)
│   ├── go/               # Go generated code
│   ├── typescript/       # TypeScript generated code
│   └── python/           # Python generated code
├── scripts/
│   └── generate.sh       # Generation script
├── Makefile              # Build automation
├── go.mod                # Go module definition
└── README.md
```

## Versioning

Protocol versions follow semantic versioning:
- **Major**: Breaking changes to message structure
- **Minor**: New fields (backward compatible)
- **Patch**: Documentation, bug fixes

Current version: **v0.1.0**

## Error Codes

| Code | Name | Description |
|------|------|-------------|
| 0 | UNSPECIFIED | Unknown error |
| 1 | INTERNAL | Internal server error |
| 2 | INVALID_REQUEST | Invalid request parameters |
| 3 | UNAUTHORIZED | Authentication required |
| 4 | FORBIDDEN | Permission denied |
| 5 | NOT_FOUND | Resource not found |
| 6 | CONFLICT | Resource conflict |
| 7 | ROOM_FULL | Room at capacity |
| 8 | TRACK_NOT_FOUND | Track not found |
| 9 | PARTICIPANT_NOT_FOUND | Participant not found |
| 10 | NETWORK_ERROR | Network communication error |

## Development

### Validate Proto Files

```bash
make validate
```

### Clean Generated Files

```bash
make clean
```

### Add New Message Types

1. Edit or create `.proto` files in `proto/`
2. Follow Proto3 syntax
3. Add appropriate imports
4. Run `make generate`
5. Test in all target languages

### Example: Adding a New Message

```protobuf
// In proto/custom.proto
syntax = "proto3";

package zenc.protocol;

import "common.proto";

option go_package = "github.com/cyper98/zenc-protocol/go/protocol";

message CustomMessage {
  string id = 1;
  string data = 2;
  Error error = 3;
}
```

## Best Practices

1. **Always use enums for constants** - More type-safe than strings
2. **Include error fields** - Every response should have optional `Error`
3. **Use maps for metadata** - `map<string, string>` for extensibility
4. **Timestamp as int64** - Unix epoch in seconds for consistency
5. **Reserve field numbers** - Don't reuse deleted field numbers

## Testing

```bash
# Test generated Go code
make test

# Manual testing
cd generated/go
go test ./...
```

## Contributing

1. Edit `.proto` files only
2. Run `make validate` before committing
3. Regenerate code with `make generate`
4. Test in all languages
5. Update this README if adding new types

## License

Apache License 2.0 - see [LICENSE](LICENSE) for details.

## Links

- [Protocol Buffers Documentation](https://protobuf.dev/)
- [Go protobuf](https://pkg.go.dev/google.golang.org/protobuf)
- [ts-proto](https://github.com/stephenh/ts-proto)
- [Zenc Documentation](https://zenc.example.com/docs)
