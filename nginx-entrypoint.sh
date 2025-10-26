#!/bin/sh
# nginx-entrypoint.sh

set -e

# Logic to determine which pool is primary and which is backup
if [ "$ACTIVE_POOL" = "green" ]; then
    export BLUE_ROLE="backup"
    export GREEN_ROLE=""
    echo "NGINX: Active pool is GREEN. Blue is backup."
else
    # Default to blue active
    export BLUE_ROLE=""
    export GREEN_ROLE="backup"
    echo "NGINX: Active pool is BLUE. Green is backup."
fi

# Substitute the variables in the template
# We list the variables envsubst should look for.
envsubst '$BLUE_ROLE $GREEN_ROLE $APP_PORT' < /etc/nginx/templates/default.conf.template > /etc/nginx/conf.d/default.conf

echo "NGINX: Configuration generated."
cat /etc/nginx/conf.d/default.conf

# Start Nginx in the foreground
exec nginx -g 'daemon off;'
