
# Spread packaged with Docker #

This packages [Spread Toolkit](http://www.spread.org/) for use with Docker. The latest version is available at:

* https://github.com/jopereira/spread

## Building ##

Docker (and optionally docker-compose) is needed:

* https://docs.docker.com/get-docker/
* https://docs.docker.com/compose/install/

Download Spread Toolkit sources from:

* http://www.spread.org/download/spread-src-5.0.1.tar.gz

and save them in `./image/spread-src-5.0.1.tar.gz`.

Build with:

    $ docker-compose build

or, without compose, with:

    $ docker build -t spread:5.0.1 image/

## Running (one peer, compose not needed) ##

Run a single peer with:

    $ docker run -p 4803:4803 --name spread_alfa_1 -it spread:5.0.1

Test with:

    $ docker exec -it spread_alfa_1 spuser

In Java, connect to default server (i.e., `"4803@localhost"`).

Kill and remove server with:

    $ docker kill spread_alfa_1
    $ docker rm spread_alfa_1

## Running (three peers, with compose) ##

Run a network with three peers (*alfa*, *bravo*, and *charlie*) with:

    $ docker-compose up

Test with:

    $ docker exec -it spread_alfa_1 spuser
    $ docker exec -it spread_bravo_1 spuser
    $ docker exec -it spread_charlie_1 spuser

In Java, connect to:

* default server or `"localhost", 4803` for peer *alfa*
* `"localhost", 4804` for peer *bravo*
* `"localhost", 4805` for peer *charlie*

Kill and remove servers with:

    $ docker-compose down

You can kill and restart a single server (e.g., *charlie*), to simulate faults with:

    $ docker kill spread_charlie_1
    $ docker-compose up charlie

## Java library

The Java library can be obtained from a running container with:

    $ docker cp spread_alfa_1:/usr/lib/java/spread-5.0.1.jar .

It can be added to a project in the IDE directly or installed locally for use with maven with:

    $ mvn install:install-file -Dfile=spread-5.0.1.jar \
        -DgroupId=org.spread -DartifactId=spread \
        -Dversion=5.0.1 -Dpackaging=jar

and used with the following dependency:

    <dependency>
        <groupId>org.spread</groupId>
        <artifactId>spread</artifactId>
        <version>5.0.1</version>
    </dependency>

## Simulating network partitions

The Docker network can be partitioned to simulated network faults.
To disconnect host *charlie*:

	$ ./dnu.sh disconnect charlie

To query current status of all hosts:

	$ ./dnu.sh status alfa bravo charlie

To reconnect a hosts *bravo* and *charlie*:

	$ ./dnu.sh connect bravo charlie

## Documentation

Man pages for Spread C API are available in running containers, for instance:

    $ docker exec -it spread_alfa_1 man SP_connect

More documentation, including Java API can be obtained with:

    $ docker cp spread_alfa_1:/usr/share/doc/spread/ docs

