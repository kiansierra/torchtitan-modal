FROM nvidia/cuda:12.4.1-devel-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV UV_COMPILE_BYTECODE=1

# Install system dependencies
# python3-venv is typically required for creating venvs on Ubuntu
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    git \
    slurm-client \
    slurm-wlm \
    && rm -rf /var/lib/apt/lists/*

# Install uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

WORKDIR /app

# Copy dependency files
COPY pyproject.toml uv.lock ./

# Install dependencies
# --frozen ensures we stick to the lockfile
# --no-install-project avoids needing the source code at this step (for caching)
RUN uv sync --frozen --no-install-project --no-cache

COPY . .

# # Install the project itself
# RUN uv sync --frozen --no-cache

# Set environment to use the virtual environment created by uv
ENV PATH="/app/.venv/bin:$PATH"
