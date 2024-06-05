# Ollama Behind Caddy Proxy

Caddy server to securely authenticate and proxy requests to a local Ollama instance, utilizing environment-based API key validation for enhanced security.

## Features

- **Secure API Access**: Uses Caddy to enforce API key authentication, allowing only requests with valid `Bearer` token/api-key.
- **Flexible Interaction**: Supports all endpoints to interact with the Ollama API.
- **Dockerized Setup**: Both Ollama and Caddy are containerized.
- **Latest Versions**: Utilizes the latest versions of Ollama and Caddy, ensuring the setup benefits from the most recent updates, security patches, and features. Docker image is configured to pull the latest versions automatically.

## Requirements

- Docker
- Docker Compose

## Installation

Clone the repository:

```bash
git clone https://github.com/bartolli/ollama-bearer-auth.git
cd ollama-bearer-auth
```

## Configuration

To customize the server behavior and update the API key, you need to modify the `Caddyfile` and `.env.local` files according to your requirements.

## Generating a Secure API Key

To generate a secure API key, you can use a cryptographic random method. This ensures the key is both unique and secure. Make sure you have `openssl` installed on your machine. You can generate the key with the following one-liner, adjust the `sk-ollama-` prefix to whatever you want:

```bash
echo "sk-ollama-$(openssl rand -hex 16)"
```

Copy the generated key and update your `.env.local` file with the new API key.

## Build and Run the Services Using Docker Compose

```bash
docker-compose up -d
```

## Testing API Key Authentication

### Test with Incorrect API Key

Test the server's response with an incorrect API key. This should return a `401 Unauthorized` status:

```bash
curl -i http://localhost:8081 -H "Authorization: Bearer wrong_api_key"
```

### Test with Correct API Key

Now use the API key generated earlier. This should return a `200 OK` status:

```bash
curl -i http://localhost:8081 -H "Authorization: Bearer correct_api_key"
```

Replace `correct_api_key` with the actual API key you generated.

Note: This project is a modified and improved clone of [ollama-auth](https://github.com/g1ibby/ollama-auth), which originally used a basic auth configuration and a fixed version of Caddy. This enhanced version leverages environment-based API key validation for enhanced security and automatically pulls the latest versions of both Ollama and Caddy.