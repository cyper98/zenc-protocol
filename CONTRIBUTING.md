# Contributing to Zenc Protocol

Thank you for contributing to **Zenc Protocol**! This repository defines the canonical data models, event schemas, and RPC interfaces across the entire Zenc livestreaming ecosystem.

---

## Key Principles & Rules

> [!IMPORTANT]
> **Never edit generated files directly!**
> All files inside `generated/go/`, `generated/typescript/`, and `generated/python/` are generated automatically from `.proto` source files. Any manual changes will be overwritten.

### Backward Compatibility Rules
Protocol changes impact clients across Web, Mobile, and Server. All updates must maintain backward compatibility:
1. **Never renumber field tags**: Once a field tag (e.g., `string id = 1;`) is assigned, its number can never be reused.
2. **Never change field types**: Changing a field from `int32` to `string` breaks serialization.
3. **Use `reserved` for deprecated fields**: If removing a field, mark its tag and name as `reserved`.
4. **Prefer optional/additive changes**: Add new fields with new tag numbers rather than modifying existing fields.

---

## Development Workflow

### Prerequisites
- **Protocol Buffers Compiler (`protoc`)** v3.x+ or v20+
- **Go 1.22+** with `protoc-gen-go`:
  ```bash
  go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
  ```
- **Node.js 18+** with `ts-proto`:
  ```bash
  npm install -g ts-proto
  ```
- **Python 3.8+** (optional, for python bindings)

### Step-by-Step Contribution Process
1. Fork and clone the repository:
   ```bash
   git clone https://github.com/<your-username>/zenc-protocol.git
   cd zenc-protocol
   ```
2. Modify the proto definitions inside the `proto/` directory:
   - `proto/common.proto`
   - `proto/room.proto`
   - `proto/participant.proto`
   - `proto/track.proto`
   - `proto/signaling.proto`
3. Regenerate code for all supported languages:
   ```bash
   make generate
   ```
4. Verify that generated code compiles cleanly:
   ```bash
   # Test Go generation
   cd examples/go && go run main.go && cd ../..
   ```

---

## Pull Request Guidelines

1. Ensure all modified `.proto` files and their newly regenerated files in `generated/` are staged and committed.
2. Follow Conventional Commits:
   - `feat(proto): add connection quality metrics to participant`
   - `fix(proto): reserve removed audio level field tag`
3. Sign off your commits using `git commit -s`:
   ```bash
   git commit -s -m "feat(proto): your descriptive message"
   ```
By submitting a Pull Request, you agree that your contributions will be licensed under the project's **Apache License 2.0**.

