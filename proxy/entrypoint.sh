#!/bin/sh

set -e

export LOG_FILE="/var/log/envoy/access.log"
mkdir -p $(dirname ${LOG_FILE})
touch ${LOG_FILE}

launch_envoy() {
  ENVOY_TEMPLATE_FILE="$1"
  ENVOY_TARGET_FILE="$2"
  ENVOY_BASE_ID="$3"
  RETRY_INTERVAL="$4"

  while true; do
    if [ -f ${ENV_FILE} ]; then
      set -a
      . ${ENV_FILE}
      set +a
    fi

    if [ -f "${ENVOY_TEMPLATE_FILE}" ]; then
      python -c \
'import os
import sys
import jinja2
sys.stdout.write(
    jinja2.Template(sys.stdin.read()
).render(env=os.environ))' <${ENVOY_TEMPLATE_FILE} >${ENVOY_TARGET_FILE}

      rm -rf \
        ${ENVOY_TEMPLATE_FILE}
    fi

    echo ""
    echo "Starting Envoy with configuration file: ${ENVOY_TARGET_FILE}"

    # Start Envoy and break if successful
    if /usr/local/bin/envoy -c ${ENVOY_TARGET_FILE} --base-id ${ENVOY_BASE_ID}; then
      break
    fi

    # If there's a retry interval, then wait for it before retrying
    if [ -n "$RETRY_INTERVAL" ]; then
      echo "Envoy failed to start. Retrying in ${RETRY_INTERVAL} seconds..."
      sleep ${RETRY_INTERVAL}
    else
      break
    fi
  done
}

# Don't really care about the logs for this one.
launch_envoy /tmp/envoy.http.template.yaml /etc/envoy/http.yaml 1 & > /dev/null

launch_envoy /tmp/envoy.https.template.yaml /etc/envoy/https.yaml 2 15