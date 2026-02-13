# RunPod Serverless Dockerfile for FLUX.2
FROM runpod/base:0.6.2-cuda12.4.0

# Set working directory
WORKDIR /workspace

# Install system dependencies
RUN apt-get update && apt-get install -y \
    python3.11 \
    python3-pip \
    git \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip and install build tools
RUN pip3 install --upgrade pip setuptools wheel

# Copy requirements first for better layer caching
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

# Install RunPod SDK
RUN pip3 install runpod

# Copy application code
COPY handler.py .
COPY src/ ./src/

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV MODEL_NAME=black-forest-labs/FLUX.2-dev
ENV PYTHONPATH=/workspace

# Start RunPod handler
CMD ["python3", "-u", "handler.py"]
