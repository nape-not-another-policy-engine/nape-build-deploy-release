# Define the Rust targets for different architectures
SOURCE_PATH = ~/nape-cli/source
PROJECT_NAME = nape_collection_cli

LINUX_X86_64_GNU_TARGET = x86_64-unknown-linux-gnu
LINUX_AARCH64_GNU_TARGET = aarch64-unknown-linux-gnu

LINUX_X86_64_MUSL_TARGET = x86_64-unknown-linux-musl
LINUX_AARCH64_MUSL_TARGET = aarch64-unknown-linux-musl

WINDOWS_X86_64_TARGET = x86_64-pc-windows-gnu

MACOS_X86_64_TARGET = x86_64-apple-darwin
MACOS_AARCH64_TARGET = aarch64-apple-darwin

# Binary name
BINARY_NAME = nape

# Run tests
test:
	@echo "Running tests..."
	cargo test --verbose

# Build release for all targets
build-release: build-linux build-windows build-macos

# Build release for Linux targets
build-linux: build-linux-x86_64-gnu build-linux-aarch64-gnu build-linux-x86_64-musl build-linux-aarch64-musl

build-linux-x86_64-gnu:
	@echo "Building Linux x86_64 (GNU)..."
	RUSTFLAGS="-C link-args=-L/usr/lib/x86_64-linux-gnu" \
	/usr/local/bin/setup_env.sh x86_64 cargo build --release --target x86_64-unknown-linux-gnu --manifest-path $(SOURCE_PATH)/Cargo.toml -p $(PROJECT_NAME)

build-linux-aarch64-gnu:
	@echo "Building Linux aarch64 (GNU)..."
	RUSTFLAGS="-C link-args=-L/usr/lib/aarch64-linux-gnu" \
	/usr/local/bin/setup_env.sh aarch64 cargo build --release --target aarch64-unknown-linux-gnu --manifest-path $(SOURCE_PATH)/Cargo.toml -p $(PROJECT_NAME)

build-linux-x86_64-musl:
	@echo "Building Linux x86_64 (MUSL)..."
	cargo build --release --target $(LINUX_X86_64_MUSL_TARGET) --manifest-path $(SOURCE_PATH)/Cargo.toml -p $(PROJECT_NAME)

build-linux-aarch64-musl:
	@echo "Building Linux aarch64 (MUSL)..."
	cargo build --release --target $(LINUX_AARCH64_MUSL_TARGET) --manifest-path $(SOURCE_PATH)/Cargo.toml -p $(PROJECT_NAME)

# Build release for Windows targets
build-windows: build-windows-x86_64

build-windows-x86_64:
	@echo "Building Windows x86_64 (GNU)..."
	cargo build --release --target $(WINDOWS_X86_64_TARGET) --manifest-path $(SOURCE_PATH)/Cargo.toml -p $(PROJECT_NAME)

# Build release for macOS targets
build-macos: build-macos-x86_64 build-macos-aarch64

build-macos-x86_64:
	@echo "Building macOS x86_64..."
	cargo build --release --target $(MACOS_X86_64_TARGET) --manifest-path $(SOURCE_PATH)/Cargo.toml -p $(PROJECT_NAME)

build-macos-aarch64:
	@echo "Building macOS aarch64..."
	cargo build --release --target $(MACOS_AARCH64_TARGET) --manifest-path $(SOURCE_PATH)/Cargo.toml -p $(PROJECT_NAME)

# Clean the target directories
clean:
	@echo "Cleaning up build artifacts..."
	cargo clean

# Run everything: test and build all release binaries
all: test build-release

.PHONY: test build-release build-linux build-windows build-macos clean all