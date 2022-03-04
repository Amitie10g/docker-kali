#!/bin/bash
#
# 20_xrdp
#

SERVICE=xrdp.sh

if test -f "/etc/init.d/$SERVICE"; then
    /etc/init.d/$SERVICE start
fi
