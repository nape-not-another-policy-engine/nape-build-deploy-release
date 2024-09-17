# Use the latest Ubuntu Linux as the base image
FROM ubuntu:20.04

LABEL org.opencontainers.image.title="NAPE Container - Build System - Linux X86 64bit"
LABEL org.opencontainers.image.description="A base container which contains all the build tools required to build, deploy, and release any NAPE software component."
LABEL org.opencontainers.image.version="1.0.0"
LABEL org.opencontainers.image.authors="Bill Bensing <https://www.linkedin.com/in/billbensing>"
LABEL org.opencontainers.image.licenses="Apache 2.0"
LABEL org.opencontainers.image.url="https://napecentral.com"
LABEL org.opencontainers.image.documentation="https://docs.napecentral.com"
LABEL org.opencontainers.image.source="https://github.com/nape-not-another-policy-engine/nape-build-deploy-release"
LABEL org.opencontainers.image.vendor="NAPE"

ARG DEBIAN_FRONTEND=noninteractive

# Install necessary packages as root
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    git \
    libssl-dev \
    pkg-config \
    python3 \
    python3-pip \
    cmake \
    musl-tools \
    musl-dev \
    gcc-aarch64-linux-gnu \
    libc6-dev-arm64-cross \
    clang \
    lld \
    make \
    unzip \
    xz-utils

# Install osxcross dependencies
RUN apt-get install -y \
    automake \
    cmake \
    libtool \
    libxml2-dev \
    uuid-dev \
    zlib1g-dev

# Install Zig (for cross-compilation)
RUN curl -L https://ziglang.org/download/0.9.0/zig-linux-x86_64-0.9.0.tar.xz | tar -xJ && \
    mv zig-linux-x86_64-0.9.0 /opt/zig

# Set environment variables for Zig
ENV PATH="/opt/zig:$PATH"

# Upgrade pip and install nape as root
RUN pip3 install --upgrade pip
RUN pip3 install nape

# Create a non-root user with a home directory
RUN useradd -ms /bin/bash nape-builder

# Set permissions on the home directory
RUN chown -R nape-builder:nape-builder /home/nape-builder

# Switch to the non-root user
USER nape-builder

# Set the HOME environment variable
ENV HOME=/home/nape-builder

# Install Rust as the non-root user
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Ensure that cargo and rustc are in the PATH
ENV PATH="$HOME/.cargo/bin:${PATH}"

# Add Rust targets for Linux (x86_64 and aarch64), Windows, and macOS
RUN rustup target add x86_64-unknown-linux-gnu
RUN rustup target add x86_64-unknown-linux-musl
RUN rustup target add aarch64-unknown-linux-gnu
RUN rustup target add aarch64-unknown-linux-musl
RUN rustup target add x86_64-pc-windows-gnu
RUN rustup target add x86_64-apple-darwin
RUN rustup target add aarch64-apple-darwin

# Set the working directory to the user's home directory
WORKDIR /home/nape-builder

# Set permissions on the home directory
RUN chmod 700 /home/nape-builder

CMD ["bash"]