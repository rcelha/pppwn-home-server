################
# BUILD STAGES #
################
# TODO: Build stages for all FW versions
FROM ubuntu:24.04 as stage_builder

RUN apt update && apt install -y build-essential
RUN mkdir /build /output

COPY ./vendor/PPPwn /build
WORKDIR /build

RUN make -C stage1 FW=1100 clean && make -C stage1 FW=1100 && cp stage1/stage1.bin /output/stage1_1100.bin
RUN make -C stage2 FW=1100 clean && make -C stage2 FW=1100 && cp stage2/stage2.bin /output/stage2_1100.bin

###################
# BUILD pppwn cpp #
###################
FROM ubuntu:24.04 as pppwn_cpp_builder

RUN apt update && apt install -y build-essential cmake git libpcap-dev

ADD ./vendor/PPPwn_cpp /build

WORKDIR /build
RUN cmake -B build && cmake --build build -t pppwn

########################################################
# Service Image to run auto pppwn with network sharing #
########################################################
FROM ubuntu:24.04
RUN apt update && \
    apt install -y ppp pppoe nmap iproute2 ufw netcat-traditional psmisc

# TODO: Re-enable stage building
# COPY --from=stage_builder /output/ /usr/src/app/stages
COPY --from=pppwn_cpp_builder /build/build/pppwn /usr/bin
COPY ./stages /usr/src/app/stages

ADD ./src /usr/src/app
ADD ./etc/pap-secrets /etc/ppp/
ADD ./etc/pppoe-server-options /etc/ppp/
ADD ./etc/ipaddress_pool /etc/ppp/
ADD ./etc/ufw /etc/default/

WORKDIR /usr/src/app
CMD ./run
