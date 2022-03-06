# Kali Linux plus kalitorify on Docker image (WIP)
This is an attemp to bring Kali Linux into a Docker image, using the [Kali Linux rolling](https://hub.docker.com/r/kalilinux/kali-rolling) base image.

[Dockerfile](https://github.com/Amitie10g/docker-kali/blob/main/Dockerfile)

## Tags

There are several tags for you:<sup>[1]</sup>

* ``amitie10g/baseimage:kali`` the base image built with the [Phusion's base image](https://github.com/phusion/baseimage-docker) project<sup>[2]</sup>

* ``base`` base image with basic tools, TOR, and kalitorify
  * ``nano``
  * ``lynx``
  * ``make``
  * ``tor``

* ``latest`` ``desktop`` base desktop (XFCE and XRDP) plus Kali top 10 tools and Midori browser (small)<sup>[3]</sup>
  * ``kali-tools-top10``
  * ``kali-desktop-xfce``
  * ``xrdp``
  * ``midori``

* ``headless`` base Kali Linux toolset that includes CLI-only tools (large)<sup>[3]</sup>
  * ``kali-linux-headless``

* ``desktop-plus`` both desktop and headless (large)

* ``default`` default Kali Linux toolset (larger)
   * ``kali-linux-default``

* ``large`` larger Kali Linux toolset (huge, not available)<sup>[4]</sup>
  * ``kali-linux-large``

* ``full`` ``everything`` full Kali Linux toolset (huge, not available)<sup>[4]</sup>
  * ``kali-linux-everything``

### Footnotes

* <sup>[1]</sup> The Dockerfile applies each RUN instruction in order to optimize the building contexts. Lower RUN instructions are commented to use only the upper ones, allowing several tags.
* <sup>[2]</sup> The base image has been built with the [Phusion's base image](https://github.com/phusion/baseimage-docker) project, using the vanilla [kali-rolling](https://hub.docker.com/r/kalilinux/kali-rolling) container base image. This container base images replaces [systemd](https://wiki.debian.org/systemd) with [s6-overlay](https://github.com/just-containers/s6-overlay), making easier to bring the desired services, but causing issues on programs that assumes the presence of systemctl; the way to handle the services is with the ```service`` command.
* <sup>[3]</sup> desktop, headless or both.
* <sup>[4]</sup> Those containers are not available at Hub due the huge size (15 and 25 GB); you need to build them by yourself.

## Usage

First, boot up the container in dettached mode:

```
docker run -d --name kali -v $(pwd}/kali:/home/kali amitie10g/kali-linux:<tag>
```

Then, connect to interactive shell:

```
docker exec --user kali -it kali bash
```

Start XRDP service (automatically started by default)

```
docker exec kali service xrdp start
```

Start kalitorify (not automatically started by default)

```
docker exec kali kalitorify --tor
```

User and password is ``kali``.

### Further options
* Add ``-p 3389:3389`` when running ``docker run`` to expose Remote Desktop por to connect via XRDP
* Add ``--cap-add=NET_ADMIN --cap-add=NET_RAW`` when running ``docker run`` to allow kalitorify to modify iptables and set up it successfully
* Remove ``-v $(pwd}/kali:/home/kali`` when running ``docker exec`` for ephimeral container
* Remove ``--user kali`` when running ``docker exec`` to get interactive shell as root

## Building
It is highly recommended to use [AptCacherNg](https://wiki.debian.org/AptCacherNg) to avoid re-download packages, as Kali needs huge ammount of packages. I provide [AptCacherNg Docker container](https://hub.docker.com/r/amitie10g/apt-cacher-ng); to use it, run

```
docker network create mynetwork
docker run -d -p 3142:3142 --network=mynetwork -v $(pwd)/cache:/var/cache/apt-cacher-ng amitie10g/apt-cacher-ng
```
Then, run this container using the AptCacherNg running container as proxy (check the IP address of the AptCacherNg running container)

```
docker build --build-arg APT_PROXY=172.21.0.2 --network=mynetwork -t amitie10g/kali-linux:<tag> .
```

## Caveats
* This is a work in progress; not everything will work seamlessly. At least, **Metasploit** worked during my tests.
* Remote connections via XRDP/VNC make unable to run graphical programs that needs **superuser** using **polkit** due settings; please see [this thread](https://askubuntu.com/questions/1174742/not-authorized-to-perform-operation-polkit-authority-not-available) at AskUbuntu. You're still able to run console programs using **sudo**.

## FAQ
* Q: Why you created this project<br>
  A: I'm preparing for diploma in cybersecurity, and as my hobby is create Docker containers, I created this as part of my tasks. As this will be useful for everyone, I'be compromised to maintain this project.

* Q: Why s6-overlay<br>
  A: Because this eases the process of bringing required services for tools (eg. Postgres for Metasploit).

* Q: Why XRDP instead o VNC?<br>
  A: a) most of the users uses Windows, and the Remote Desktop client is integrated, and runs seamlessly; and b) performance.

## Licensing

* The Dockerfile is released into the Public domain (The Unlicense)
* The software contained in the container images are subjected to the respective licenses
