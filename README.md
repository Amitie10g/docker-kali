# Kali Linux plus kalitorify on Docker image (WIP)
This is an attemp to bring Kali Linux into a Docker image, using the [Kali Linux rolling](https://hub.docker.com/r/kalilinux/kali-rolling) base image.

[Dockerfile](https://github.com/Amitie10g/kali-rolling/blob/main/Dockerfile)

## Tags

There are five tags:

* ``latest`` ``desktop`` base desktop (XFCE and XRDP) plus Kali top 10 tools (small)
  * ``kali-tools-top10``
  * ``kali-desktop-xfce``
  * ``xrdp``

* ``headless`` base Kali Linux toolset that includes CLI-only tools (large)
  * ``kali-linux-headless``

* ``desktop-plus`` desktop plus headless (large)

* ``default`` default Kali Linux toolset (large)
   * ``kali-linux-default``

* ``large`` larger Kali Linux toolset (not available)
  * ``kali-linux-large``

* ``full`` ``everything`` full Kali Linux toolset (not available)
  * ``kali-linux-everything``

## Usage

First, boot up the container in dettached mode:

```
docker run -d --name kali -v $(pwd}/kali:/home/kali amitie10g/kali-linux:<tag>
```

Then, connect to interactive shell:

```
docker exec --user kali -it kali bash
```

Start XRDP service

```
docker exec kali service xrdp start
```

User and password is ``kali``.

### Further options
* Add ``-p 3389:3389`` to expose Remote Desktop por to connect via XRDP
* Remove ``-v $(pwd}/kali:/home/kali`` for ephimeral container
* Remove ``--user kali`` when running ``docker exec`` to get interactive shell as root

## Building
Is highly recommended to use [AptCacherNg](https://wiki.debian.org/AptCacherNg) to avoid re-download packages, as Kali needs huge ammount of packages. I provide [AptCacherNg Docker container](https://hub.docker.com/r/amitie10g/apt-cacher-ng); to use it, run

```
docker network create mynetwork
docker run -d -p 3142:3142 --network=mynetwork -v $(pwd)/cache:/var/cache/apt-cacher-ng amitie10g/apt-cacher-ng
```
Then, run this container using the AptCacherNg running container as proxy (check the IP address of the AptCacherNg running container)

```
docker build --build-arg APT_PROXY=172.21.0.2 --network=mynetwork -t amitie10g/kali-linux:<tag> .
```

## Caveats
* This is a work in progress; everything will work seamlessly. At least, **Metasploit** worked during my tests.
* Remote connections via XRDP/VNC make unable to run graphical programs that needs **superuser** using **polkit**; please see [this thread](https://askubuntu.com/questions/1174742/not-authorized-to-perform-operation-polkit-authority-not-available) at AskUbuntu. You're still able to run console programs using **sudo**.

## Licensing

* The Dockerfile is released into the Public domain (The Unlicense)
* The software contained in the container images are subjected to the respective licenses
