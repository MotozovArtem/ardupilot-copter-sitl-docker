FROM ubuntu:18.04

LABEL org.opencontainers.image.authors='Artem Motozov <motozov.a.v@gmail.com>'

ARG TAG=Copter-3.6.8-hotfix

RUN apt-get update && \
    apt-get install -y python3 python3-pip git curl && \
    ln -s /usr/bin/python3 /usr/bin/python && \
    ln -s /usr/bin/pip3 /usr/bin/pip

WORKDIR /sitl

RUN git clone https://github.com/ArduPilot/ardupilot.git && \
    cd ardupilot && \
    git checkout ${TAG} && \
    git config --global url."https://".insteadOf git:// && \
    git submodule update --init --recursive && \
    pip install future pymavlink MAVProxy empy pexpect

WORKDIR /sitl/ardupilot

RUN ./waf distclean
RUN ./waf configure --board sitl
RUN ./waf copter

ENV LAT -35.3632622
ENV LON 149.1652375
ENV ALT 584.80
ENV HEADING_NORTH 0

ENTRYPOINT /sitl/ardupilot/Tools/autotest/sim_vehicle.py -w --console -v ArduCopter --no-rebuild --custom-location=${LAT},${LON},${ALT},${HEADING_NORTH}