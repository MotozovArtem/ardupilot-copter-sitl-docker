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