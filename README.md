# Kali Linux plus kalitorify on Docker image
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

User and password is ``kali``. Sudo is enabled for that user 

### Headless
``docker run -it -v $(pwd}/kali:/home/kali amitie10g/kali-linux:headless``

### Desktop using XRDP (use the tag of your choice)
``docker run -it -v $(pwd}/kali:/home/kali -p 3389:3389 amitie10g/kali-linux``

Then, open your Remote Desktop client and login using the ``kali`` username (see above)

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
This is the vanilla Kali Linux docker base image with meta packages installed. Sudo is enmabled for the user ``kali``; however, due the lack of [polkit](https://wiki.debian.org/PolicyKit) graphical agent, you need to use ``pkttyagent`` from the terminal emulator:

``pkttyagent -p $(echo $$) | pkexec <program>``

Also, you need to start the services ``xrdp`` for desktop access and ``dbus`` for performing actions required by it (polkit) **before** opening a Remote Desktop connection:

```
service dbus start
service xrdp start
```

## Licensing

* The Dockerfile is released into the Public domain (The Unlicense)
* The software contained in the container images are subjected to the respective licenses
