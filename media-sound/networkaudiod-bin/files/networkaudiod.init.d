#!/sbin/openrc-run
# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

description="Network Audio Daemon"

user="networkaudiod:networkaudiod"
logfile="/var/log/networkaudiod.log"
command="/usr/sbin/networkaudiod"
command_args="-D"
pidfile="/run/networkaudiod.pid"
start_stop_daemon_args="--pidfile ${pidfile} --user ${user}"

depend() {
    need net
    use alsasound
    after bootmisc
}

start_pre() {
    checkpath --file --owner $user --mode 0644 $logfile
}
