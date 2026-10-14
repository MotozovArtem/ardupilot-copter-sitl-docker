# ArduPilot ArduCopter SITL Docker Image


This Docker image allows you build and run ArduPilot SITL with ArduCopter vehicle simulation.

## How to build 

Build Docker image from Dockerfile:
```bash
docker build -t arducopter-sitl . 
```

## How to run

### Default location
Run ArduPilot ArduCopter SITL with default SITL location and heading:
```bash
docker run -it -p 5760:5760 -p 5762:5762 \
    --name arducopter-sitl-container-name 
    arducopter-sitl
```

### Specific location
Run ArduPilot ArduCopter SITL with specified location and heading:
```bash
docker run -it -p 5760:5760 -p 5762:5762 \
    --name arducopter-sitl-container-name \
    --env LAT=56.8625617 \
    --env LON=24.1131178 \
    --env ALT=11.86 \
    --env HEADING_NORTH=0 \
    arducopter-sitl
```

## 4.7.0 (lightweight image)

The `4.7.0` image is a multi-stage build: it runs the `arducopter` SITL binary directly (no MAVProxy and no build toolchain), on `debian:bookworm-slim`.

```bash
docker build -t arducopter-sitl:4.7.0 4.7.0
```

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

### Options
| Variable | Default | Description |
|---|---|---|
| `MODE` | `tcp` | `tcp` or `udp` |
| `GCS_HOST` | `host.docker.internal` | GCS host for UDP mode |
| `GCS_PORT` | `14550` | GCS port for UDP mode |
| `LAT`, `LON`, `ALT`, `HEADING_NORTH` | Canberra | Home location |
| `SERIAL0`, `SERIAL1`, `SERIAL2` | | Raw SITL serial setting that overrides the defaults, e.g. `tcp:0`, `udpclient:10.0.0.5:14550` |

Arguments added after the image name go straight to `arducopter`, e.g. `--speedup 2` or `--sysid 2`.
