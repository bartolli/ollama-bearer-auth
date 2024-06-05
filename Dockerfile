FROM ollama/ollama

# Install dependencies
RUN apt-get update && apt-get install -y wget jq

# Download and install the latest Caddy
RUN LATEST_CADDY_URL=$(wget -qO- "https://api.github.com/repos/caddyserver/caddy/releases/latest" | jq -r '.assets[] | select(.name | endswith("_linux_amd64.tar.gz")).browser_download_url') \
    && wget --no-check-certificate "$LATEST_CADDY_URL" -O caddy.tar.gz \
    && tar -xvf caddy.tar.gz -C /usr/bin caddy \
    && chown root:root /usr/bin/caddy \
    && chmod 755 /usr/bin/caddy

# Copy the Caddyfile and .env.local to the container
COPY Caddyfile /etc/caddy/Caddyfile
COPY .env.local /etc/caddy/.env.local

# Set the environment variable for the ollama host
ENV OLLAMA_HOST 0.0.0.0

# Load environment variables from the .env.local file
RUN echo "source /etc/caddy/.env.local" >> /root/.bashrc

# Expose the port that caddy will listen on
EXPOSE 80

# Copy a script to start both ollama and caddy
COPY start_services.sh /start_services.sh
RUN chmod +x /start_services.sh

# Set the entrypoint to the script
ENTRYPOINT ["/start_services.sh"]