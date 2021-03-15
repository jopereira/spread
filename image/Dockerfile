FROM openjdk:8 AS build

RUN apt-get update && apt-get -y install make gcc ant
COPY spread-src-5.0.1.tar.gz /
RUN tar xvf /spread-src-5.0.1.tar.gz 
RUN cd spread-src-5.0.1 && ./configure && make && make install
RUN cd spread-src-5.0.1/java && ant javadocs install

FROM debian:buster

RUN apt-get update && apt-get -y install socat man && rm -rf /var/lib/apt/lists/*

COPY --from=build /usr/local/bin/* /usr/bin/
COPY --from=build /usr/local/sbin/* /usr/sbin/
COPY --from=build /usr/local/lib/* /usr/lib/
COPY --from=build /usr/local/share/doc/spread /usr/share/doc/spread
COPY --from=build /spread-src-5.0.1/docs/*.3 /usr/share/man/man3/
RUN ldconfig

COPY --from=build /usr/lib/java/spread-4.4.0.jar /usr/lib/java/spread-5.0.1.jar
COPY --from=build /spread-src-5.0.1/java/docs /usr/share/doc/spread/javadoc

COPY spread.conf /
RUN mkdir -p /var/run/spread/ && chown nobody.nogroup /var/run/spread

CMD [ "bash", "-c", "spread -n localhost & exec socat TCP4-LISTEN:5000,reuseaddr,fork TCP4:localhost:4803" ]

