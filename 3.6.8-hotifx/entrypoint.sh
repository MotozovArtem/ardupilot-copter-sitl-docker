#!/bin/sh
set -e

SERIAL0="${SERIAL0:-tcp:0}"
SERIAL1="${SERIAL1:-tcp:2}"
SERIAL2="${SERIAL2:-tcp:3}"

case "$MODE" in
    tcp)
        ;;
    udp)
        # SITL 3.6 has no UDP output, so bridge SERIAL0 TCP port to the GCS with socat
        GCS_IP=$(getent ahostsv4 "$GCS_HOST" | awk 'NR==1 {print $1}')
        if [ -z "$GCS_IP" ]; then
            echo "Cannot resolve GCS_HOST '$GCS_HOST'" >&2
            exit 1
        fi
        echo "Bridging tcp:5760 to udp:${GCS_IP}:${GCS_PORT}"
        (
            while true; do
                socat "UDP4:${GCS_IP}:${GCS_PORT}" "TCP4:127.0.0.1:5760,retry=60,interval=0.5" || true
                sleep 1
            done
        ) &
        ;;
    *)
        echo "Unknown MODE '$MODE', expected 'tcp' or 'udp'" >&2
        exit 1
        ;;
esac

echo "SERIAL0=$SERIAL0 SERIAL1=$SERIAL1 SERIAL2=$SERIAL2"

# SITL 3.6 names serial ports by UART: SERIAL0=uartA, SERIAL1=uartC, SERIAL2=uartD
exec /sitl/arducopter \
    --model + \
    --wipe \
    --defaults /sitl/copter.parm \
    --home "${LAT},${LON},${ALT},${HEADING_NORTH}" \
    --uartA "$SERIAL0" \
    --uartC "$SERIAL1" \
    --uartD "$SERIAL2" \
    "$@"
