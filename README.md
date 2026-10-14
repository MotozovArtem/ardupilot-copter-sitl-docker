# ArduPilot ArduCopter SITL Docker Image


These Docker images build and run ArduPilot SITL with ArduCopter vehicle simulation.

Each version folder (`3.6.8-hotifx`, `4.3.7`, `4.5.7`, `4.7.0`) is a lightweight multi-stage build: it runs the `arducopter` SITL binary directly (no MAVProxy and no build toolchain in the final image).

| Folder | ArduPilot tag | Runtime base |
|---|---|---|
| `3.6.8-hotifx` | `Copter-3.6.8-hotfix` | `ubuntu:18.04` |
| `4.3.7` | `Copter-4.3.7` | `ubuntu:22.04` |
| `4.5.7` | `Copter-4.5.7` | `debian:bookworm-slim` |
| `4.7.0` | `Copter-4.7.0` | `debian:bookworm-slim` |

## How to build

```bash
docker build -t arducopter-sitl:4.7.0 4.7.0
```

## How to run

### TCP mode (default)
SITL listens on TCP ports 5760 (SERIAL0), 5762 (SERIAL1) and 5763 (SERIAL2):
```bash
docker run -it -p 5760:5760 -p 5762:5762 arducopter-sitl:4.7.0
```

### UDP mode
SITL sends MAVLink over UDP to a GCS that listens on `GCS_HOST:GCS_PORT` (the GCS uses UDP "listen"/udpin mode). TCP ports 5762 and 5763 stay available.
```bash
docker run -it -e MODE=udp -e GCS_HOST=host.docker.internal -e GCS_PORT=14550 \
    -p 5762:5762 arducopter-sitl:4.7.0
```
On Linux, also add `--add-host=host.docker.internal:host-gateway`.

SITL 3.6.8 has no UDP output, so in that image SERIAL0 stays on TCP 5760 inside the container and `socat` bridges it to the GCS over UDP.

### Specific location
```bash
docker run -it -p 5760:5760 -p 5762:5762 \
    --env LAT=56.8625617 \
    --env LON=24.1131178 \
    --env ALT=11.86 \
    --env HEADING_NORTH=0 \
    arducopter-sitl:4.7.0
```

### Options
| Variable | Default | Description |
|---|---|---|
| `MODE` | `tcp` | `tcp` or `udp` |
| `GCS_HOST` | `host.docker.internal` | GCS host for UDP mode |
| `GCS_PORT` | `14550` | GCS port for UDP mode |
| `LAT`, `LON`, `ALT`, `HEADING_NORTH` | Canberra | Home location |
| `SERIAL0`, `SERIAL1`, `SERIAL2` | | Raw SITL serial setting that overrides the defaults, e.g. `tcp:0`, `udpclient:10.0.0.5:14550` (`udpclient` is not available in 3.6.8) |

Arguments added after the image name go straight to `arducopter`, e.g. `--speedup 2` or `--sysid 2`.
