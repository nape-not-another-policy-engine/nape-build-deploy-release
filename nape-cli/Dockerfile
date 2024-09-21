# Use the latest Ubuntu Linux as the base image
FROM ubuntu:24.04

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

# Add support for multiple architectures (arm64 and amd64)
RUN dpkg --add-architecture amd64 && dpkg --add-architecture arm64
RUN apt-get update

# Install necessary packages as root
RUN apt-get install -y \
    curl \
    git \
    pkg-config \
    python3 \
    python3-pip \
    cmake \
    musl-tools \
    musl-dev \
    clang \
    lld \
    make \
    nano \
    unzip \
    xz-utils

# Install cross-compilation tools for both x86_64 and aarch64
RUN apt-get install -y \
    build-essential \
    gcc-aarch64-linux-gnu \
    gcc-x86-64-linux-gnu \
    libc6-dev-arm64-cross \
    libc6-dev-amd64-cross \
    libssl-dev \
    libssl-dev:arm64 \
    libssl-dev:amd64

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

# Add the dynamic environment setup script
COPY setup_env.sh /usr/local/bin/setup_env.sh

# Ensure the script is executable
RUN chmod +x /usr/local/bin/setup_env.sh

# Upgrade pip and install nape as root
RUN pip3 install --upgrade pip
RUN pip3 install nape

# Create a non-root user with a home directory
# RUN useradd -ms /bin/bash nape-builder

# Set permissions on the home directory
# RUN chown -R nape-builder:nape-builder /home/nape-builder

# Switch to the non-root user
# USER nape-builder

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

# Create the target directory inside the container
RUN mkdir -p /home/nape-builder/nape-cli/build-tools

# Copy everything from the local directory "./nape-cli" to "/home/nape-builder/nape-cli"
COPY .cargo /root/.cargo
COPY /action /home/nape-builder/nape-cli/build-tools/action
COPY /Makefile /home/nape-builder/nape-cli/build-tools/Makefile

# Set the working directory to the user's home directory
WORKDIR /home/nape-builder

RUN mkdir nape-cli/source
RUN git clone https://github.com/nape-not-another-policy-engine/nape nape-cli/source

# Set permissions on the home directory
# RUN chmod 700 /home/nape-builder

CMD ["bash"]