#!/bin/bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}Generating protocol buffers...${NC}"

# Get the directory of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROTO_DIR="${SCRIPT_DIR}/../proto"
OUTPUT_DIR="${SCRIPT_DIR}/../generated"

# Create output directories
mkdir -p "${OUTPUT_DIR}/go/protocol"
mkdir -p "${OUTPUT_DIR}/typescript"
mkdir -p "${OUTPUT_DIR}/python"

# Check if protoc is installed
if ! command -v protoc &> /dev/null; then
    echo -e "${RED}Error: protoc is not installed${NC}"
    echo "Please install protoc:"
    echo "  macOS: brew install protobuf"
    echo "  Ubuntu: apt-get install protobuf-compiler"
    exit 1
fi

echo -e "${YELLOW}Checking protoc plugins...${NC}"

# Check Go plugin
if ! command -v protoc-gen-go &> /dev/null; then
    echo -e "${YELLOW}Installing protoc-gen-go...${NC}"
    go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
fi

# Check TypeScript plugin
if ! command -v protoc-gen-ts &> /dev/null; then
    echo -e "${YELLOW}Warning: protoc-gen-ts not installed${NC}"
    echo "To generate TypeScript:"
    echo "  npm install -g ts-proto"
fi

# Generate Go code
echo -e "${GREEN}Generating Go code...${NC}"
protoc \
    --proto_path="${PROTO_DIR}" \
    --go_out="${OUTPUT_DIR}/go" \
    --go_opt=paths=source_relative \
    "${PROTO_DIR}"/*.proto

echo -e "${GREEN}✓ Go code generated${NC}"

# Generate TypeScript code (if ts-proto is available)
if command -v protoc-gen-ts &> /dev/null; then
    echo -e "${GREEN}Generating TypeScript code...${NC}"
    protoc \
        --proto_path="${PROTO_DIR}" \
        --plugin=protoc-gen-ts \
        --ts_out="${OUTPUT_DIR}/typescript" \
        "${PROTO_DIR}"/*.proto
    echo -e "${GREEN}✓ TypeScript code generated${NC}"
else
    echo -e "${YELLOW}Skipping TypeScript generation (ts-proto not installed)${NC}"
fi

# Generate Python code (if needed)
if command -v protoc-gen-python &> /dev/null || protoc --version | grep -q "libprotoc"; then
    echo -e "${GREEN}Generating Python code...${NC}"
    protoc \
        --proto_path="${PROTO_DIR}" \
        --python_out="${OUTPUT_DIR}/python" \
        "${PROTO_DIR}"/*.proto
    echo -e "${GREEN}✓ Python code generated${NC}"
else
    echo -e "${YELLOW}Skipping Python generation${NC}"
fi

echo -e "${GREEN}Done! Generated files are in ${OUTPUT_DIR}${NC}"
