# [Unbound](https://unbound.docs.nlnetlabs.nl/en/latest/ "Official Documentation")-DOCKERIZED
[![Image Version](https://img.shields.io/github/v/release/Bleala/Unbound-DOCKERIZED?sort=semver&display_name=tag&style=flat&label=Version&link=https%3A%2F%2Fgithub.com%2FBleala%2FUnbound-DOCKERIZED%2Freleases)](https://github.com/Bleala/Unbound-DOCKERIZED/releases)
[![Docker Stars](https://img.shields.io/docker/stars/bleala/unbound?style=flat&label=Docker%20Stars)](https://hub.docker.com/r/bleala/unbound)
[![Docker Pulls](https://img.shields.io/docker/pulls/bleala/unbound?style=flat&label=Docker%20Pulls)](https://hub.docker.com/r/bleala/unbound)
[![Docker Build Check 🐳✅](https://github.com/Bleala/Unbound-DOCKERIZED/actions/workflows/docker-build-check.yaml/badge.svg)](https://github.com/Bleala/Unbound-DOCKERIZED/actions/workflows/docker-build-check.yaml)

Unbound - a validating, recursive, and caching DNS resolver. DOCKERIZED!

---

## About Unbound
**Disclaimer:** I am just the maintainer of this docker container, I did not write the software. Visit the [Official Unbound Website](https://nlnetlabs.nl/projects/unbound/about/ "Official Unbound Website") or the [Official Unbound Github Repository](https://github.com/NLnetLabs/unbound "Unbound Github Repository") to thank the author(s)! :)

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

My Github Repository: https://github.com/Bleala/Unbound-DOCKERIZED

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

## Image Signing & Verification

To ensure the authenticity and integrity of my images, all `bleala/unbound` images pushed to `Docker Hub` and `GitHub Container Registry` (and maybe more in the future) are signed using [Cosign](https://github.com/sigstore/cosign "Cosign").

I use a static key pair for signing. The public key required for verification, `cosign.pub`, is available in the root of this GitHub repository:
* **Public Key:** [`cosign.pub`](https://github.com/Bleala/Unbound-DOCKERIZED/blob/main/cosign.pub "cosign.pub")

### How to Verify an Image

You can verify the signature of an image to ensure it hasn't been tampered with and originates from me.

1.  **Install Cosign:**
    If you don't have Cosign installed, follow the official installation instructions: [Cosign Installation Guide](https://docs.sigstore.dev/cosign/system_config/installation/ "Cosign Installation Guide").

2.  **Obtain the Public Key:**
    Download the [`cosign.pub`](https://github.com/Bleala/Unbound-DOCKERIZED/blob/main/cosign.pub "cosign.pub") file from this repository or clone the repository to access it locally.

3.  **Verify the Image:**
    Use the `cosign verify` command. It is highly recommended to verify against the image **digest** (e.g., `sha256:...`) rather than a mutable tag (like `latest` or `1.23.0`). You can find image digests on Docker Hub or GitHub Container Registry.

    ```bash
    # Ensure 'cosign.pub' is in your current directory, or provide the full path to it.
    # Replace <registry>/bleala/unbound@sha256:<image-digest> with the actual image reference and its digest.

    # Example for an image on Docker Hub:
    cosign verify --key cosign.pub docker.io/bleala/unbound@sha256:<ACTUAL_IMAGE_DIGEST_HERE>

    # Example for an image on GitHub Container Registry:
    cosign verify --key cosign.pub ghcr.io/bleala/unbound@sha256:<ACTUAL_IMAGE_DIGEST_HERE>
    ```

    For instance, to verify the `dev` tag with the following digest `sha256:94aa316e0aa6a845f8e275946df1280c589d3b2104c08dc3ae838eb208b9aed7`:
    ```bash
    cosign verify --key cosign.pub docker.io/bleala/unbound@sha256:94aa316e0aa6a845f8e275946df1280c589d3b2104c08dc3ae838eb208b9aed7
    ```

    A successful verification will output information like this:

    ```
    cosign verify --key cosign.pub docker.io/bleala/unbound@sha256:94aa316e0aa6a845f8e275946df1280c589d3b2104c08dc3ae838eb208b9aed7

    Verification for index.docker.io/bleala/unbound@sha256:94aa316e0aa6a845f8e275946df1280c589d3b2104c08dc3ae838eb208b9aed7 --
    The following checks were performed on each of these signatures:
      - The cosign claims were validated
      - Existence of the claims in the transparency log was verified offline
      - The signatures were verified against the specified public key

    [{"critical":{"identity":{"docker-reference":"index.docker.io/bleala/unbound"},"image":{"docker-manifest-digest":"sha256:94aa316e0aa6a845f8e275946df1280c589d3b2104c08dc3ae838eb208b9aed7"},"type":"cosign container image signature"},"optional":{"Bundle":{"SignedEntryTimestamp":"MEQCIH8kniH21V+t7h1kjuUVUQZLpJcuYmIfKri5Iu81HCxMAiB2a1eRVOHT3oxfGsRilbuoQoVPCakzZ7nS10p6dkRGWg==","Payload":{"body":"eyJhcGlWZXJzaW9uIjoiMC4wLjEiLCJraW5kIjoiaGFzaGVkcmVrb3JkIiwic3BlYyI6eyJkYXRhIjp7Imhhc2giOnsiYWxnb3JpdGhtIjoic2hhMjU2IiwidmFsdWUiOiIzODdkZmY3NTUxOWExNTI2MzY4NTVlZjA1YjRhZjUwY2FkYjVlMjU2N2M5NDFhN2VhZmE3NDdmMGM2NmFlMDM2In19LCJzaWduYXR1cmUiOnsiY29udGVudCI6Ik1FUUNJQ3R2L0Y1bUo2U0hBODdzVTNrNnYwQmhLb0dIUUJUNEtocTVFL1V0VmZ2bUFpQW9QNy96VHcwN2ZIYkU4NGt0RmdoaitaK0Z3L2NyVGZ1NU1MRFVBU3NEV2c9PSIsInB1YmxpY0tleSI6eyJjb250ZW50IjoiTFMwdExTMUNSVWRKVGlCUVZVSk1TVU1nUzBWWkxTMHRMUzBLVFVacmQwVjNXVWhMYjFwSmVtb3dRMEZSV1VsTGIxcEplbW93UkVGUlkwUlJaMEZGU0VWWFRFYzVjVVI2VFdGdlJ6TlJTSGxXTUhoVFRVZzNRblF3VGdvMVRVWkRNWEV3VFhabE5DOHZVMmwxZVZWbU5VRnBaRVJZY2s5S1kwaEdSalYxZERWUVMyNVViMUZ6YjNWNWRGVTBXVmhoWlM5bU1UQlJQVDBLTFMwdExTMUZUa1FnVUZWQ1RFbERJRXRGV1MwdExTMHRDZz09In19fX0=","integratedTime":1748639173,"logIndex":226072545,"logID":"c0d23d6ad406973f9559f3ba2d1ca01f84147d8ffc5b8445c224f98b9591801d"}}}}]
    ```

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
      UNBOUND_CONFIG: /etc/unbound/unbound.conf
      # Optional: set diffenrent Unbound root.key file location, default to /var/unbound/root.key
      UNBOUND_ROOT_FILE: /var/unbound/root.key
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

In this projects GitHub repository, you will find the `unbound.conf` ([Link](https://github.com/Bleala/Unbound-DOCKERIZED/tree/main/docker/files/examples "unbound.conf")) that can serve as a starting point and which is the default `unbound.conf`, if you do not provide your own.

You can also mount a local configuration file named `unbound.conf` into the container (`/etc/unbound/unbound.conf`) to use your own `Unbound` configuration.<br>
You can find all possible configuration options in the [official Unbound documentation](https://unbound.docs.nlnetlabs.nl/en/latest/manpages/unbound.conf.html).

If you prodive your own `unbound.conf` I suggest that you include the following config:

```
  # User to drop privileges to after binding ports.
  # This must match the user created in your Dockerfile.
  username: "unbound"

  # Unbound's working directory. Used for relative paths if chroot is enabled.
  # If chroot is disabled, this is where Unbound might look for some files by default.
  directory: "/var/unbound"

  # Chroot: path to chroot the server to.
  # Empty string "" means no chroot, which simplifies path management in Docker.
  chroot: "/var/unbound"

  # PID file location.
  # Ensure the directory (/var/unbound) is writable by the 'unbound' user
  # if Unbound manages the pidfile after dropping privileges.
  # (Typically, root creates it before dropping privileges).
  pidfile: "unbound.pid"

  # File with the trusted root key for DNSSEC validation.
  # This file is typically created/updated by the `unbound-anchor` utility.
  # Your Dockerfile runs unbound-anchor to create this.
  auto-trust-anchor-file: "root.key"
```

As `Unbound` is compiled with the corresponding flags ([see Dockerfile](https://github.com/Bleala/Unbound-DOCKERIZED/blob/main/docker/Dockerfile "Dockerfile")) during the build process, you should add this config.<br>
The default runtime directory for `Unbound` inside the container is `/var/unbound`.

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

### CacheDB module with Redis/Valkey backend

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
      UNBOUND_CONFIG: /etc/unbound/unbound.conf
      # Optional: set diffenrent Unbound root.key file location, default to /var/unbound/root.key
      UNBOUND_ROOT_FILE: /var/unbound/root.key
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

You can set three different environment variables if you want to:

| **Variable** | **Info** | **Value** |
|:----:|:----:|:----:|
|   `TZ`   |   To set the correct container and log time   |   optional, default to `Europe/Vienna`, look [here](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones "Timezones") for possible values  |
|   `UNBOUND_CONFIG`   |   Set a custom path where `unbound` should look for an `unbound.conf`    |   optional, default to `/etc/unbound/unbound.conf` |
|   `UNBOUND_ROOT_FILE`   |   Set a custom path where `unbound` should look for the `root.key`    |   optional, default to `/var/unbound/root.key` |

---

## Build instructions

Clone this repo and then:

```
cd Unbound-DOCKERIZED/docker
docker build -t bleala/unbound:dev .
```

Or you can use the provided [docker-compose.override.yml](https://github.com/Bleala/Unbound-DOCKERIZED/blob/master/docker/docker-compose.override.yml "docker-compose.override.yml") file:

```
docker compose -f docker-compose.override.yml build
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
**1.23.0 - 30.05.2025:**
* Initial Release.
* Unbound Version: 1.23.0
* Alpine Version: 3.21.3

**Current Versions:**<br>
* Unbound 1.23.0, Alpine 3.21.3

<details>
<summary>Old Version History</summary><br>

**1.23.0 - 30.05.2025:**
* Initial Release.
* Unbound Version: 1.23.0
* Alpine Version: 3.21.3

</details>

---
### Hope you enjoy it! :)
---
