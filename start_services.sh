#!/bin/bash

# Print the environment variable for debugging
echo "OLLAMA_API_KEY: '$OLLAMA_API_KEY'"

# Ensure required environment variables are set
if [ -z "$OLLAMA_API_KEY" ]; then
    echo "OLLAMA_API_KEY is not set. Exiting."
    exit 1
fi

# Start ollama in the background
ollama serve &
OLLAMA_PID=$!
# Start caddy in the background
caddy run --config /etc/caddy/Caddyfile &
CADDY_PID=$!

# Function to check process status
check_process() {
    wait $1
    STATUS=$?
    if [ $STATUS -ne 0 ]; then
        echo "Process $2 ($1) has exited with status $STATUS"
        exit $STATUS
    fi
}

# Handle shutdown signals
trap "kill $OLLAMA_PID $CADDY_PID; exit 0" SIGTERM SIGINT

# Wait for both services to start and monitor them
while true; do
    if ! ps -p $OLLAMA_PID > /dev/null; then
        echo "Ollama service is not running, checking for exit status"
        check_process $OLLAMA_PID "Ollama"
        # Only restart if check_process hasn't exited the script
        echo "Starting Ollama now"
        ollama serve &
        OLLAMA_PID=$!
    fi
    if ! ps -p $CADDY_PID > /dev/null; then
        echo "Caddy service is not running, checking for exit status"
        check_process $CADDY_PID "Caddy"
        # Only restart if check_process hasn't exited the script
        echo "Starting Caddy now"
        caddy run --config /etc/caddy/Caddyfile &
        CADDY_PID=$!
    fi
    sleep 1
done