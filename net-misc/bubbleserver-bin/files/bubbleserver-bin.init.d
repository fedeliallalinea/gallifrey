#!/sbin/openrc-run
# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

description="BubbleUPnP Server Daemon"

logfile="/var/log/bubbleserver-bin.log"
command="/opt/bubbleserver-bin/launch.sh"
command_args="-nologfile -disableAutoUpdate"
pidfile="/run/bubbleserver-bin.pid"
start_stop_daemon_args="--background --make-pidfile --stderr ${logfile}"

depend() {
    need net
    use alsasound
    after bootmisc
}

start_pre() {
    checkpath --file --mode 0644 $logfile
}

stop() {
    ebegin "Stopping bubbleserver-bin"
    start-stop-daemon --stop --exec $command\
    --retry 15 --pidfile $pidfile
    eend $?
}
