#!/sbin/openrc-run
# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

description="Runs rtapp script every few time"

user="rtapp:rtapp"
logfile="/var/log/rtapp-timer.log"
command="/usr/bin/rtapp-timer"
pidfile="/run/rtapp-timer.pid"
start_stop_daemon_args="--background --make-pidfile --pidfile ${pidfile} --user ${user} --stdout ${logfile}"

depend() {
    need localmount
    after bootmisc
}

start_pre() {
    checkpath --file --owner ${user} --mode 0644 ${logfile}
}
