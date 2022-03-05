#!/bin/bash
#
# 20_xrdp.sh
#

SERVICE=xrdp

if test -f "/etc/init.d/$SERVICE"; then
    /etc/init.d/$SERVICE start
fi
