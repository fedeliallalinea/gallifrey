# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop rpm xdg-utils

DESCRIPTION="VPN client used to connect to F5Networks BIG-IP APM 13.0"
HOMEPAGE="https://support.f5.com/csp/article/K32311645#link_04_05"
SRC_URI="${P}.rpm"

LICENSE="f5"
SLOT="0"
KEYWORDS="-* ~amd64"

RESTRICT="bindist fetch"

S="${WORKDIR}/opt/f5/vpn/"

QA_PREBUILT="
	opt/f5/vpn/lib/*.so*
	opt/f5/vpn/platforms/*.so
	opt/f5/vpn/f5vpn
	opt/f5/vpn/svpn
	opt/f5/vpn/tunnelserver
"

pkg_nofetch() {
	einfo
	einfo "Please visit"
	einfo
	einfo "  https://downloads.f5.com/"
	einfo
	einfo "and download "
	einfo
	einfo "  linux_f5vpn.x86_64.rpm (version ${PV})"
	einfo
	einfo "which must be renamed in "
	einfo
	einfo " ${P}.rpm"
	einfo
	einfo "and placed in DISTDIR directory."
	einfo
}

# see https://github.com/zrhoffman/f5vpn-arch/
src_install() {
	insinto /opt/f5/vpn
	doins -r logos

	exeinto /opt/f5/vpn/lib
	doexe lib/libicu{data,i18n,uc}.so.55
	doexe lib/libQt5{Core,DBus,Gui,Network,OpenGL,PrintSupport,Sql,WebKit,WebKitWidgets,Widgets,XcbQpa}.so.5
	doexe lib/lib{ssl,crypto}.so.1.0.0

	exeinto /opt/f5/vpn/platforms
	doexe platforms/libqxcb.so

	exeinto /opt/f5/vpn
	doexe {f5vpn,svpn,tunnelserver}
	# f5vpn should not be run as non-root, but it calls svpn which must be run as root
	fperms u+s /opt/f5/vpn/svpn

	dosym ../f5/vpn/f5vpn /opt/bin/f5vpn
	dosym ../f5/vpn/svpn /opt/bin/svpn
	dosym ../f5/vpn/tunnelserver /opt/bin/tunnelserver

	domenu com.f5.f5vpn.desktop
}

pkg_postinst() {
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
}
