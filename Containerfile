# Start from a base image that suits your needs (e.g. Ubuntu 22.04)
FROM ubuntu:22.04

# Avoid interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Update packages and install dependencies:
#   - build-essential for GCC make, etc.
#   - libx11-dev for building X11 apps
#   - xvfb and x11-xserver-utils (which includes xmodmap)
#   - x11-apps (useful for some debugging, not strictly required)
#   - git if you want to clone inside the container
RUN apt-get update && apt-get install -y \
    build-essential \
    libx11-dev \
    xvfb \
    x11-xserver-utils \
    x11-apps \
    git \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /app

# Copy the entire repo into the container (including your Makefile, test.sh, etc.)
COPY . /app

# By default, just drop into a shell (you can override in CI or at runtime)
CMD ["/bin/bash"]
