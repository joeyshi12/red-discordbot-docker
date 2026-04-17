FROM python:3.11-slim-bookworm

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    SODIUM_INSTALL=system

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    jq \
    libffi-dev \
    libsodium-dev \
    openjdk-17-jre-headless \
    tini \
    && rm -rf /var/lib/apt/lists/*

COPY docker/entrypoint.sh /usr/local/bin/redbot-entrypoint
RUN chmod +x /usr/local/bin/redbot-entrypoint

VOLUME ["/data"]
WORKDIR /data

ENTRYPOINT ["tini", "--", "/usr/local/bin/redbot-entrypoint"]
