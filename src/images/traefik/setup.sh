#!/bin/sh

TRAEFIK_CONFIG_FILE=/etc/traefik/traefik.yml
TRAEFIK_DYNAMIC_CONFIG_DIR=/etc/traefik/dynamic
PASSWORD_DECODE=$(echo "$TRAEFIK_BASIC_AUTH_PASSWORD_HASH" | openssl enc -d -base64)

# Modify traefik config
if [[ -f "$TRAEFIK_CONFIG_FILE" ]]; then
  sed -i "$TRAEFIK_CONFIG_FILE" \
    -e "s#__LOG_LEVEL#$TRAEFIK_LOG_LEVEL#g" \
    -e "s#__TRAEFIK_API_DASHBOARD#$TRAEFIK_API_DASHBOARD#g" \
    -e "s#__TRAEFIK_API_INSECURE#$TRAEFIK_API_INSECURE#g" \
    -e "s#__DOMAIN_NAME#$TRAEFIK_DOMAIN_NAME#g" \
    -e "s#__DOCKER_NETWORK#$TRAEFIK_DOCKER_NETWORK#g" \
    -e "s#__DOCKER_ENTRYPOINT#$TRAEFIK_DOCKER_ENTRYPOINT#g" \
    -e "s#__ACME_EMAIL_ADDRESS#$TRAEFIK_ACME_EMAIL_ADDRESS#g" \
    -e "s#__ACME_DNS_CHALLENGE_PROVIDER#$TRAEFIK_ACME_DNS_CHALLENGE_PROVIDER#g"
fi

if [[ -f "$TRAEFIK_DYNAMIC_CONFIG_DIR/dashboard.yml" ]]; then
  sed -i "$TRAEFIK_DYNAMIC_CONFIG_DIR/dashboard.yml" \
    -e "s#__TRAEFIK_API_DASHBOARD_SUBDOMAIN#$TRAEFIK_API_DASHBOARD_SUBDOMAIN#g" \
    -e "s#__DOMAIN_NAME#$TRAEFIK_DOMAIN_NAME#g"
fi

if [[ -f "$TRAEFIK_DYNAMIC_CONFIG_DIR/middlewares.yml" ]]; then
  sed -i "$TRAEFIK_DYNAMIC_CONFIG_DIR/middlewares.yml" \
    -e "s#__TRAEFIK_BASIC_AUTH_USERNAME#$TRAEFIK_BASIC_AUTH_USERNAME#g" \
    -e "s#__TRAEFIK_BASIC_AUTH_PASSWORD_HASH#$PASSWORD_DECODE#g" \
    -e "s#__TRAEFIK_HEADER_X_ROBOTS_TA#$TRAEFIK_HEADER_X_ROBOTS_TA#g" \
    -e "s#__TRAEFIK_HEADER_REFERRER_POLICY#$TRAEFIK_HEADER_REFERRER_POLICY#g" \
    -e "s#__TRAEFIK_HEADER_FRAME_DENY#$TRAEFIK_HEADER_FRAME_DENY#g" \
    -e "s#__TRAEFIK_HEADER_CONTENT_SECURITY_POLICY#$TRAEFIK_HEADER_CONTENT_SECURITY_POLICY#g" \
    -e "s#__TRAEFIK_HEADER_PERMISSION_POLICY#$TRAEFIK_HEADER_PERMISSION_POLICY#g" \
    -e "s#__TEAEFIK_HEADER_CORS_LIST#$TEAEFIK_HEADER_CORS_LIST#g"
fi

exec "$@"
