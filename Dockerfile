# Use the official Rust image as a base image
FROM rust:latest AS builder

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy the Cargo.toml and Cargo.lock files
COPY Cargo.toml Cargo.lock ./

# Copy the source code
COPY src ./src

# Build the application in release mode
RUN cargo build --release

# Use a compatible Ubuntu image to run the binary (with OpenSSL 3)
FROM ubuntu:22.04

# Install OpenSSL, curl, and other necessary libraries
RUN apt-get update && apt-get install -y \
    libssl-dev \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Copy the built binary from the builder stage
COPY --from=builder /usr/src/app/target/release/client-request /usr/local/bin/client-request

# Run the binary
CMD ["client-request"]
