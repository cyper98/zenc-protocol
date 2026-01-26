.PHONY: all generate clean install-deps test

all: generate

# Install dependencies
install-deps:
	@echo "Installing dependencies..."
	@go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
	@echo "✓ Go dependencies installed"
	@echo ""
	@echo "For TypeScript generation, install:"
	@echo "  npm install -g ts-proto"
	@echo ""
	@echo "For Python generation, protoc is sufficient"

# Generate all protocol buffers
generate:
	@chmod +x scripts/generate.sh
	@./scripts/generate.sh

# Generate only Go
generate-go:
	@echo "Generating Go protocol buffers..."
	@mkdir -p generated/go/protocol
	@protoc \
		--proto_path=proto \
		--go_out=generated/go \
		--go_opt=paths=source_relative \
		proto/*.proto
	@echo "✓ Go code generated"

# Generate only TypeScript
generate-ts:
	@echo "Generating TypeScript protocol buffers..."
	@mkdir -p generated/typescript
	@protoc \
		--proto_path=proto \
		--plugin=protoc-gen-ts \
		--ts_out=generated/typescript \
		proto/*.proto
	@echo "✓ TypeScript code generated"

# Generate only Python
generate-python:
	@echo "Generating Python protocol buffers..."
	@mkdir -p generated/python
	@protoc \
		--proto_path=proto \
		--python_out=generated/python \
		proto/*.proto
	@echo "✓ Python code generated"

# Clean generated files
clean:
	@echo "Cleaning generated files..."
	@rm -rf generated/go/*
	@rm -rf generated/typescript/*
	@rm -rf generated/python/*
	@echo "✓ Cleaned"

# Test generated Go code
test:
	@cd generated/go && go test ./...

# Format proto files
format:
	@echo "Formatting proto files..."
	@find proto -name "*.proto" -exec clang-format -i {} \;
	@echo "✓ Formatted"

# Validate proto files
validate:
	@echo "Validating proto files..."
	@protoc --proto_path=proto --descriptor_set_out=/dev/null proto/*.proto
	@echo "✓ All proto files are valid"

help:
	@echo "Available targets:"
	@echo "  make generate       - Generate code for all languages"
	@echo "  make generate-go    - Generate only Go code"
	@echo "  make generate-ts    - Generate only TypeScript code"
	@echo "  make generate-python - Generate only Python code"
	@echo "  make clean          - Remove generated files"
	@echo "  make install-deps   - Install required tools"
	@echo "  make validate       - Validate proto files"
	@echo "  make test           - Run tests on generated code"
