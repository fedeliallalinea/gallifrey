# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop unpacker xdg

DESCRIPTION="VPN client used to connect to F5Networks BIG-IP APM"
HOMEPAGE="https://www.f5.com/ https://support.f5.com/csp/article/K32311645#link_04_05"
SRC_URI="https://vpn.f5.com/public/download/linux_${PN}.x86_64.deb -> ${P}.x86_64.deb"

LICENSE="f5"
SLOT="0"
KEYWORDS="-* ~amd64"

RESTRICT="bindist mirror strip"

S="${WORKDIR}/opt/f5/vpn/"

QA_PREBUILT="
	opt/f5/vpn/lib/*.so*
	opt/f5/vpn/platforms/*.so
	opt/f5/vpn/plugins/**/*.so
	opt/f5/vpn/f5vpn
	opt/f5/vpn/f5vpn_launch_helper.sh
	opt/f5/vpn/svpn
	opt/f5/vpn/tunnelserver
"

# see https://github.com/zrhoffman/f5vpn-arch/
src_install() {
	local bn exe_ver item size

	exe_ver=$(grep -oEm1 --text '[0-9]+(\.[0-9]+){3}' svpn)
	if [ "${exe_ver}" != "${PV}" ]; then
		eerror "The f5 executable and ebuild versions don't match"
		die "Please create a new f5vpn ebuild for ${exe_ver} version"
	fi

	insinto /opt/f5/vpn
	doins -r resources translations

	exeinto /opt/f5/vpn/lib
	doexe lib/*.so*

	exeinto /opt/f5/vpn/libexec
	doexe libexec/QtWebEngineProcess

	exeinto /opt/f5/vpn/platforms
	doexe platforms/libqxcb.so

	exeinto /opt/f5/vpn/plugins/tls
	doexe plugins/tls/libqopensslbackend.so
	exeinto /opt/f5/vpn/plugins/xcbglintegrations
	doexe plugins/xcbglintegrations/*.so*

	exeinto /opt/f5/vpn
	doexe {f5vpn,f5vpn_launch_helper.sh,svpn,tunnelserver}
	# f5vpn should not be run as non-root, but it calls svpn which must be run as root
	fperms u+s /opt/f5/vpn/svpn
	# For svpn.pid
	keepdir /usr/local/lib/F5Networks/SSLVPN/var/run

	dosym ../f5/vpn/f5vpn /opt/bin/f5vpn
	dosym ../f5/vpn/f5vpn_launch_helper.sh /opt/bin/f5vpn_launch_helper.sh
	dosym ../f5/vpn/svpn /opt/bin/svpn
	dosym ../f5/vpn/tunnelserver /opt/bin/tunnelserver

	for item in logos/*.png; do
		bn=$(basename "$item")
		size="${bn%x*}"
		newicon -s "${size}" "${item}" "${PN}.png"
	done

	insinto /usr/share/dbus-1/services
	doins com.f5.f5vpn.service

	domenu com.f5.f5vpn.desktop
}

pkg_postinst() {
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
	xdg_icon_cache_update
}
