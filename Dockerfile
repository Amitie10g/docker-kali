FROM amitie10g/baseimage:kali

ARG DEBIAN_FRONTEND=noninteractive

COPY init/ /etc/my_init.d/
COPY kalitorify /tmp/kalitorify
COPY excludes /etc/dpkg/dpkg.cfg.d/

# Base system plus nano, lynx, tor and kalitorify
RUN adduser --quiet --add_extra_groups --disabled-password --gecos "" kali && \
    adduser kali sudo && \
    echo "kali:kali" | chpasswd && \
    apt-get update && \
    apt-get install --no-install-suggests -y nano lynx tor make && \
    cd /tmp/kalitorify && \
    make install

# :: Install either desktop, headless, or both

# XFCE4 Desktop and top 10 toolset (latest)
RUN apt-get install -y kali-desktop-xfce xrdp kali-tools-top10

# Toolsets that don't require GUI (headless)
#RUN apt-get install -y kali-linux-headless

# ::Uncomment the following for install more toolsets. Depends on both headless and desktop

# Default Kali toolset (default)
#RUN apt-get install -y kali-linux-default

# Larger Kali toolset (large)
#RUN apt-get install -y kali-linux-large

# Full Kali toolset (full)
#RUN apt-get install -y kali-linux-everything

# ::  Cleanup and default settings
RUN /bd_build/cleanup.sh
