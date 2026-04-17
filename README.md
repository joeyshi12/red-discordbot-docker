# red-discordbot-docker

Docker image for Red Discord Bot published on the GitHub Container Registry (`ghcr.io`).

Redbot project: [Red-DiscordBot on GitHub](https://github.com/Cog-Creators/Red-DiscordBot), [Documentation](https://docs.discord.red/)

## Deployment

Use the following `compose.yaml` to run Redbot:

```yaml
services:
  redbot:
    container_name: redbot
    image: ghcr.io/joeyshi12/red-discordbot-docker:latest
    restart: unless-stopped
    environment:
      TOKEN: "${DISCORD_BOT_TOKEN}"
      PREFIX: "${DISCORD_BOT_PREFIX:-!}"
      OWNER: "${DISCORD_OWNER_ID}"
      TZ: "${TZ:-UTC}"
      REDBOT_VERSION: "${REDBOT_VERSION:-}"
      EXTRA_ARGS: "${EXTRA_ARGS:-}"
    volumes:
      - ./redbot-data:/data
```

Start the container:

```bash
docker compose up -d
```
