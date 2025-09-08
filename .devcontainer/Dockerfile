FROM ubuntu:24.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Update package list and install essential packages
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    curl \
    git \
    gnupg2 \
    libcurl4-openssl-dev \
    libpython3-dev \
    libssl-dev \
    libx11-xcb-dev \
    libxcursor-dev \
    libxi-dev \
    libxinerama-dev \
    libxml2-dev \
    libxrandr-dev \
    libz-dev \
    libz3-dev \
    mesa-common-dev \
    ninja-build \
    pkg-config \
    python3 \
    python3-pip \
    python3-venv \
    tzdata \
    unzip \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Install Swift version manager (swiftenv)
RUN curl -O https://download.swift.org/swiftly/linux/swiftly-$(uname -m).tar.gz \
    && tar zxf swiftly-$(uname -m).tar.gz \
    && ./swiftly init --quiet-shell-followup --skip-install \
    && . "${SWIFTLY_HOME_DIR:-$HOME/.local/share/swiftly}/env.sh" \
    && hash -r

# Initialize swiftenv
RUN echo 'eval "$(swiftenv init -)"' >> ~/.profile

# Set working directory
WORKDIR /workspace

# Default command
CMD ["/bin/bash"]
