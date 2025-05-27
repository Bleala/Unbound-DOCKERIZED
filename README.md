# [Unbound](https://unbound.docs.nlnetlabs.nl/en/latest/ "Official Documentation")-DOCKERIZED
[![Docker Image Version](https://img.shields.io/docker/v/bleala/unbound/latest?style=flat&label=Version)](https://hub.docker.com/r/bleala/unbound)
[![Docker Stars](https://img.shields.io/docker/stars/bleala/unbound?style=flat&label=Docker%20Stars)](https://hub.docker.com/r/bleala/unbound)
[![Docker Pulls](https://img.shields.io/docker/pulls/bleala/unbound?style=flat&label=Docker%20Pulls)](https://hub.docker.com/r/bleala/unbound)
[![CI Status](https://github.com/Bleala/Unbound-DOCKERIZED/actions/workflows/ci-docker-build.yaml/badge.svg)](https://github.com/Bleala/Unbound-DOCKERIZED/)

Unbound - a validating, recursive, and caching DNS resolver. DOCKERIZED!

---

## About Unbound
**Disclaimer:** I am just the maintainer of this docker container, I did not write the software. Visit the [Official Unbound Website](https://nlnetlabs.nl/projects/unbound/about/ "Official Unbound Website") of the [Official Unbound Github Repository](https://github.com/NLnetLabs/unbound "Unbound Github Repository") to thank the author(s)! :)

Unbound is a validating, recursive, and caching DNS resolver. It is designed to be fast and lean and incorporates modern features based on open standards.

Some of the core features of Unbound are:
* **DNSSEC:** Validates the authenticity and integrity of DNS responses.
* **Caching:** Stores DNS responses to increase speed for subsequent requests and reduce the load on upstream servers.
* **Highly Configurable:** Offers a wide range of options to fine-tune its behaviour.
* **DNS-over-TLS (DoT) & DNS-over-HTTPS (DoH):** Encrypts your DNS queries to protect your privacy and prevent eavesdropping.

---

## Links

Official Website: https://nlnetlabs.nl/projects/unbound/about/

Official Github Repository: https://github.com/NLnetLabs/unbound

Docs: https://unbound.docs.nlnetlabs.nl/en/latest/

My Github Repository: https://github.com/YourGithubName/Unbound-DOCKERIZED

---

## Downloads

Docker Hub: https://hub.docker.com/r/bleala/unbound

Github Container Registry: https://github.com/Bleala/Unbound-DOCKERIZED/pkgs/container/unbound

---

## Image, Versions and Architecture

I built this image based on [Alpine Linux](https://hub.docker.com/_/alpine "Alpine Linux Image") to keep it as slim as possible.

There will always be two different versions:

| Tag | Content |
| ------------- |:-------------:|
| latest    | Contains the latest stable version |
| x.x.x     | Contains the Unbound and Alpine versions mentioned at the bottom of the page and in the release notes |

I am using semantic versioning for this image. For all supported architectures there are the following versioned tags:

* Latest
* Major (1)
* Minor (1.0)
* Patch (1.0.0)

There are also several platforms supported:

Platforms:
* linux/amd64
* linux/arm64
* linux/arm/v7

---

## Usage

To start the container you can run the following

```
docker run -d -p 53:53/udp -p 53:53/tcp \
        -v /path/to/your/config:/etc/unbound/unbound.conf \
        bleala/unbound:latest
```

But since docker compose is easier to maintain, I'll give you a valid docker compose example.

```docker-compose.yml
networks:
  unbound:
    name: unbound
    driver: bridge

services:
  # Unbound - a validating, recursive, and caching DNS resolver. DOCKERIZED!
  # https://hub.docker.com/r/bleala/unbound
  # https://github.com/Bleala/Unbound-DOCKERIZED
  unbound:
    image: bleala/unbound:latest
    container_name: unbound
    hostname: unbound
    restart: always
    security_opt:
      - no-new-privileges:true
    environment:
      # Optional: set your timezone, for correct container and log time, default to Europe/Vienna
      TZ: Europe/Vienna
      # Optional: set different Unbound configuration file location, default to /etc/unbound/unbound.conf
      # If you use the "username" config option, set it to "unbound" and make sure the Unbound user (1000:1000) can read this file
      UNBOUND_CONFIG: /etc/unbound/unbound.conf
    env_file:
      - path: .env
        required: false
    networks:
      unbound:
    ports:
      - target: 53
        published: 53
        protocol: tcp
        mode: host
      - target: 53
        published: 53
        protocol: udp
        mode: host
    volumes:
      - type: bind
        source: /path/to/unbound.conf
        target: /etc/unbound/unbound.conf
        read_only: true
```

You can start the docker-compose.yml with the following command

```
docker compose up -d
```

If you want to see the container logs, you can run

```
docker compose logs -f
```

or

```
docker logs -f unbound
```

---

## Config

If you do not mount your own `unbound.conf` inside the container, `Unbound` will use the default `unbound.conf` I provided.<br>
The default config will just act as a DNS forwarder and will send your DNS requests to Cloudflare using DNS over TLS.

In this projects GitHub repository, you will find the `unbound.conf.example` that can serve as a starting point and which is the default `unbound.conf`, if you do not provide your own.

You can also mount a local configuration file named `unbound.conf` into the container (`/etc/unbound/unbound.conf`) to use your own `Unbound` configuration.<br>
You can find all possible configuration options in the [official Unbound documentation](https://unbound.docs.nlnetlabs.nl/en/latest/manpages/unbound.conf.html).

**Attention:** A faulty `unbound.conf` can lead to a complete breakdown of DNS resolution in your network. Test your configuration carefully! 

I recommend to test your configuration directly with the container like this:

```unbound-check-config
docker run --rm --name unbound-check-config \
        --volume /path/to/unbound.conf:/etc/unbound/unbound.conf \
        --entrypoint /files/scripts/checkconf.sh \
        bleala/unbound:latest
```

If you get a response like this `unbound-checkconf: no errors in /etc/unbound/unbound.conf`, your `unbound.conf` is valid.

And maybe set `logfile: "/dev/stdout"` in your `Unbound` configuration for the first startup, so you see all `Unbound` logs in the container logs.

Once the container is running, you can configure your router or your devices to use the Docker hosts IP address as their DNS server.

---

### CacheDB module with Redis backend

I built `Unbound` with the CacheDB option, so you can use `Redis/Valkey` as in memory cache for `Unbound`.

Add `Redis` or `Valkey` to your `docker-compose.yml` and include the following in your `unbound.conf`:

```CacheDB
server:
  module-config: "validator cachedb iterator"
cachedb:
  backend: "redis"
  redis-server-host: redis
  redis-server-port: 6379
  redis-expire-records: yes

```

---

## User

The `Unbound` container has a dedicated user called `unbound` inside, which you can (not have to) use within your `unbound.conf`.

If you set `username: "unbound"` in your `unbound.conf` the root privileges will be dropped after binding the port and the process will run as the user `unbound`.

The `UID` and `GID` for this user are `1000` by default, so be careful if you mount your `unbound.conf`, that it is readable for this user.

If you need to set a custom `UID` and `GID`, add the `user` key to your `docker-compose.yml`.

Example:
`user: "your_UID:your_GID"`

<details>
<summary>Complete docker-compose.yml with the `user` key</summary><br>

```docker-compose.yml
networks:
  unbound:
    name: unbound
    driver: bridge

services:
  # Unbound - a validating, recursive, and caching DNS resolver. DOCKERIZED!
  # https://hub.docker.com/r/bleala/unbound
  # https://github.com/Bleala/Unbound-DOCKERIZED
  unbound:
    image: bleala/unbound:latest
    container_name: unbound
    hostname: unbound
    restart: always
    user: "your_UID:your_GID"
    security_opt:
      - no-new-privileges:true
    environment:
      # Optional: set your timezone, for correct container and log time, default to Europe/Vienna
      TZ: Europe/Vienna
      # Optional: set different Unbound configuration file location, default to /etc/unbound/unbound.conf
      # If you use the "username" config option, set it to "unbound" and make sure the Unbound user (1000:1000) can read this file
      UNBOUND_CONFIG: /etc/unbound/unbound.conf
    env_file:
      - path: .env
        required: false
    networks:
      unbound:
    ports:
      - target: 53
        published: 53
        protocol: tcp
        mode: host
      - target: 53
        published: 53
        protocol: udp
        mode: host
    volumes:
      - type: bind
        source: /path/to/unbound.conf
        target: /etc/unbound/unbound.conf
        read_only: true
```

</details>

---

## Environment Variables

You can set two different environment variables if you want to:

| **Variable** | **Info** | **Value** |
|:----:|:----:|:----:|
|   `TZ`   |   To set the correct container and log time   |   optional, default to `Europe/Vienna`, look [here](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones "Timezones") for possible values  |
|   `UNBOUND_CONFIG`   |   Set a custom path where `unbound` should look for an `unbound.conf`    |   optional, default to `/etc/unbound/unbound.conf` |

---

## Build instructions

Clone this repo and then:

```
cd Unbound-DOCKERIZED/docker
docker build -t bleala/unbound:dev .
```

Or you can use the provided [docker-compose.yml](https://github.com/Bleala/Unbound-DOCKERIZED/blob/master/docker/docker-compose.override.yml "docker-compose.yml") file:

```
docker compose build
```

For more information on using multiple compose files [see here](https://docs.docker.com/compose/production/). You can also find a prebuilt docker image from [Docker Hub](https://hub.docker.com/r/bleala/unbound/ "Docker Hub"), which can be pulled with this command:

```
docker pull bleala/unbound:latest
```

---

## Contribution

I'm glad, if you want to contribute something to the `Unbound` container.

Feel free to create a PR with your changes and I will merge it, if it's ok.

**Attention**: Please use the `main` branch for pull requests, a CI pipeline is going to run to check, if the container will build!

---

## Versions
**1.0.0 - 27.05.2024:**
* Initial Release.
* Unbound Version: 1.23.0
* Alpine Version: 3.21.3

<details>
<summary>Old Version History</summary><br>

**1.0.0 - 27.05.2024:**
* Initial Release.
* Unbound Version: 1.23.0
* Alpine Version: 3.21.3

</details>

---
### Hope you enjoy it! :)
---
