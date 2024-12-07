#!/bin/bash
# setup.sh

# Generate keys
APP_KEY="base64:$(openssl rand -base64 32)"
JWT_SECRET=$(openssl rand -base64 32)

# Create or update .env file
ENV_FILE="./docker/all-in-one/.env"

# Check if .env file exists, if not create it
if [ ! -f "$ENV_FILE" ]; then
    touch "$ENV_FILE"
fi

# Update or append APP_KEY
if grep -q "^APP_KEY=" "$ENV_FILE"; then
    sed -i "s/^APP_KEY=.*$/APP_KEY=$APP_KEY/" "$ENV_FILE"
else
    echo "APP_KEY=$APP_KEY" >> "$ENV_FILE"
fi

# Update or append JWT_SECRET
if grep -q "^JWT_SECRET=" "$ENV_FILE"; then
    sed -i "s/^JWT_SECRET=.*$/JWT_SECRET=$JWT_SECRET/" "$ENV_FILE"
else
    echo "JWT_SECRET=$JWT_SECRET" >> "$ENV_FILE"
fi

echo "Keys generated and added to $ENV_FILE"
echo "APP_KEY: $APP_KEY"
echo "JWT_SECRET: $JWT_SECRET"