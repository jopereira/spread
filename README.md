
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

    $ docker run -p 4803:4803 --name spread_alfa -it spread:5.0.1

Test with:

    $ docker exec -it spread_alfa spuser

In Java, connect to default server (i.e., `"4803@localhost"`).

Kill and remove server with:

    $ docker kill spread_alfa
    $ docker rm spread_alfa

## Running (three peers, with compose) ##

Run a network with three peers (*alfa*, *bravo*, and *charlie*) with:

    $ docker-compose up

Test with:

    $ docker exec -it spread_alfa spuser
    $ docker exec -it spread_bravo spuser
    $ docker exec -it spread_charlie spuser

In Java, connect to:

* default server or `"4803@localhost"` for peer *alfa*
* `"4804@localhost"` for peer *bravo*
* `"4805@localhost"` for peer *charlie*

Kill and remove servers with:

    $ docker-compose down

You can kill and restart a single server (e.g., *charlie*), to simulate faults with:

    $ docker kill spread_charlie
    $ docker-compose up charlie

## Java library

The Java library can be obtained from a running container with:

    $ docker cp spread_alfa:/usr/lib/java/spread-5.0.1.jar .

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

## Documentation

Man pages for Spread C API are available in running containers, for instance:

    $ docker exec -it spread_alfa man SP_connect

More documentation, including Java API can be obtained with:

    $ docker cp spread_alfa:/usr/share/doc/spread/ docs

