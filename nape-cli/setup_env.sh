#!/bin/bash

# Detect architecture using uname
ARCH=$(uname -m)

# Detect target architecture (this should be passed as an argument or an environment variable)
TARGET_ARCH=$1

# Set environment variable to allow cross-compilation in pkg-config
export PKG_CONFIG_ALLOW_CROSS=1
export OPENSSL_NO_PKG_CONFIG=0

# Ensure that a target architecture is provided
if [ -z "$TARGET_ARCH" ]; then
    echo "Error: No target architecture provided. Use 'x86_64' or 'aarch64'."
    exit 1
fi

# Set OpenSSL directories based on the architecture
if [ "$TARGET_ARCH" == "x86_64" ]; then
    # For x86_64 target
    export OPENSSL_LIB_DIR="/usr/lib/x86_64-linux-gnu"
    export OPENSSL_INCLUDE_DIR="/usr/include/openssl"
    export OPENSSL_DIR="/usr"
    export PKG_CONFIG_PATH="/usr/lib/x86_64-linux-gnu/pkgconfig"
    export PKG_CONFIG_SYSROOT_DIR="/usr/x86_64-linux-gnu"
    
    # Set the correct cross-compiler for x86_64
    export CC="x86_64-linux-gnu-gcc"
    export CXX="x86_64-linux-gnu-g++"
    export TARGET_CC="x86_64-linux-gnu-gcc"
    
elif [ "$TARGET_ARCH" == "aarch64" ]; then
    # For aarch64 target
    export OPENSSL_LIB_DIR="/usr/lib/aarch64-linux-gnu"
    export OPENSSL_INCLUDE_DIR="/usr/include/aarch64-linux-gnu/openssl"
    export OPENSSL_DIR="/usr"
    export PKG_CONFIG_PATH="/usr/lib/aarch64-linux-gnu/pkgconfig"
    export PKG_CONFIG_SYSROOT_DIR="/usr/aarch64-linux-gnu"
    
    # Set the correct cross-compiler for aarch64
    export CC="aarch64-linux-gnu-gcc"
    export CXX="aarch64-linux-gnu-g++"
    export TARGET_CC="aarch64-linux-gnu-gcc"
else
    echo "Unsupported architecture: $ARCH"
    exit 1
fi

# Pass through the RUSTFLAGS if set
if [ -n "$RUSTFLAGS" ]; then
    export RUSTFLAGS="$RUSTFLAGS"
    echo "Using RUSTFLAGS: $RUSTFLAGS"
fi

# Optionally print the environment variables to verify
echo "Host ARCH: $ARCH"
echo "Target ARCH: $TARGET_ARCH"
echo "CC: $CC"
echo "Using OPENSSL_LIB_DIR=$OPENSSL_LIB_DIR"
echo "Using OPENSSL_INCLUDE_DIR=$OPENSSL_INCLUDE_DIR"
echo "Using OPENSSL_DIR=$OPENSSL_DIR"
echo "Using PKG_CONFIG_PATH: $PKG_CONFIG_PATH"
echo "Using PKG_CONFIG_SYSROOT_DIR: $PKG_CONFIG_SYSROOT_DIR"


# Check if opensslconf.h exists
if [ -f "$OPENSSL_INCLUDE_DIR/opensslconf.h" ]; then
    echo "Found opensslconf.h in $OPENSSL_INCLUDE_DIR"
else
    echo "opensslconf.h not found in $OPENSSL_INCLUDE_DIR"
    exit 1
fi

# Execute the passed command (e.g., bash, cargo build, etc.)
shift
exec "$@"