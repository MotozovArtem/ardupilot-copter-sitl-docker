FROM ubuntu:18.04 AS builder

ARG TAG=Copter-3.6.8-hotfix

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates git g++ make pkg-config python3 python3-pip python3-setuptools && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    pip3 install --no-cache-dir \
        future "empy==3.3.4" pexpect

# Old submodules use git:// URLs which GitHub no longer serves
RUN git config --global url."https://github.com/".insteadOf "git://github.com/" && \
    git clone https://github.com/ArduPilot/ardupilot.git \
        --branch=${TAG} --depth=1 \
        --recurse-submodules --shallow-submodules \
        /ardupilot

WORKDIR /ardupilot

RUN ./waf configure --board sitl && \
    ./waf copter && \
    strip build/sitl/bin/arducopter


FROM ubuntu:18.04

LABEL org.opencontainers.image.authors='Artem Motozov <motozov.a.v@gmail.com>'

RUN apt-get update && \
    apt-get install -y --no-install-recommends socat && \
    rm -rf /var/lib/apt/lists/*

COPY --from=builder /ardupilot/build/sitl/bin/arducopter /sitl/arducopter
COPY --from=builder /ardupilot/Tools/autotest/default_params/copter.parm /sitl/copter.parm
COPY entrypoint.sh /sitl/entrypoint.sh

WORKDIR /sitl

ENV LAT=-35.3632622
ENV LON=149.1652375
ENV ALT=584.80
ENV HEADING_NORTH=0

ENV MODE=tcp
ENV GCS_HOST=host.docker.internal
ENV GCS_PORT=14550

EXPOSE 5760/tcp 5762/tcp 5763/tcp

ENTRYPOINT ["/sitl/entrypoint.sh"]
