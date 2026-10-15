#!/bin/sh
set -eu
PORT="${PORT:-10000}"
SERVER_XML="$CATALINA_HOME/conf/server.xml"

# Render's health checks use HTTP HEAD requests. Disable Tomcat's separate
# shutdown socket so it cannot mistake those requests for shutdown commands.
sed -i 's/<Server port="[0-9][0-9]*" shutdown=/<Server port="-1" shutdown=/' "$SERVER_XML"

# Point the HTTP connector at Render's assigned service port.
sed -i "s/<Connector port=\"8080\"/<Connector port=\"${PORT}\"/" "$SERVER_XML"
if ! grep -q "<Connector port=\"${PORT}\"" "$SERVER_XML"; then
  echo "Tomcat HTTP connector is not configured for PORT=${PORT}" >&2
  exit 1
fi

echo "Starting Tomcat HTTP connector on PORT=${PORT}"
exec "$CATALINA_HOME/bin/catalina.sh" run
