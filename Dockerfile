# RunPod Serverless Dockerfile for FLUX.2
FROM nvidia/cuda:12.4.0-runtime-ubuntu22.04

# Set working directory
WORKDIR /workspace

# Install system dependencies
RUN apt-get update && apt-get install -y \
    python3.11 \
    python3.11-dev \
    python3-pip \
    git \
    wget \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Set python3.11 as default python3
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.11 1

# Upgrade pip and install build tools
RUN pip3 install --upgrade pip setuptools wheel

# Clone application code from GitHub (build context not provided by RunPod Hub)
RUN git clone --depth 1 https://github.com/mindoorio-hue/flux2-runpod.git /tmp/repo && \
    cp /tmp/repo/.runpod/requirements.txt . && \
    cp /tmp/repo/.runpod/handler.py . && \
    cp -r /tmp/repo/.runpod/src/ ./src/ && \
    rm -rf /tmp/repo

# Install Python dependencies
RUN pip3 install --no-cache-dir -r requirements.txt

# Install RunPod SDK
RUN pip3 install runpod

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV MODEL_NAME=black-forest-labs/FLUX.2-dev
ENV PYTHONPATH=/workspace

# Start RunPod handler
CMD ["python3", "-u", "handler.py"]
