#!/bin/sh
set -e

case "$MODE" in
    tcp)
        SERIAL0="${SERIAL0:-tcp:0}"
        ;;
    udp)
        # SITL accepts only a numeric IP for udpclient, so resolve the host name first
        GCS_IP=$(getent ahostsv4 "$GCS_HOST" | awk 'NR==1 {print $1}')
        if [ -z "$GCS_IP" ]; then
            echo "Cannot resolve GCS_HOST '$GCS_HOST'" >&2
            exit 1
        fi
        SERIAL0="${SERIAL0:-udpclient:${GCS_IP}:${GCS_PORT}}"
        ;;
    *)
        echo "Unknown MODE '$MODE', expected 'tcp' or 'udp'" >&2
        exit 1
        ;;
esac

SERIAL1="${SERIAL1:-tcp:2}"
SERIAL2="${SERIAL2:-tcp:3}"

echo "SERIAL0=$SERIAL0 SERIAL1=$SERIAL1 SERIAL2=$SERIAL2"

exec /sitl/arducopter \
    --model + \
    --wipe \
    --defaults /sitl/copter.parm \
    --home "${LAT},${LON},${ALT},${HEADING_NORTH}" \
    --serial0 "$SERIAL0" \
    --serial1 "$SERIAL1" \
    --serial2 "$SERIAL2" \
    "$@"
