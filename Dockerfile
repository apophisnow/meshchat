# Use a base image with Python 3.13
FROM python:3.13-bullseye

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    MESHCHAT_DATA=/data \
    MESHCHAT_CONFIG=/config

# Set working directory
WORKDIR /app

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl git && rm -rf /var/lib/apt/lists/*

# Install Node.js 18
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

# Clone the MeshChat repository
RUN git clone https://github.com/liamcottle/reticulum-meshchat.git .

# Install Node.js dependencies
RUN npm install --omit=dev

# Build the frontend
RUN npm run build-frontend

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose necessary port
EXPOSE 8000

# Create volumes for persistent data and configuration
VOLUME ["/data", "/config"]

# Start MeshChat
CMD ["python3", "meshchat.py", "--host", "0.0.0.0", "--reticulum-config-dir", "/config", "--storage-dir", "/data"]
