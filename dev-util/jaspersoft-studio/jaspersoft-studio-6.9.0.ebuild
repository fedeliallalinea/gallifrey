# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop

MY_PN="TIB_js-studiocomm"

DESCRIPTION="Eclipse-based report development tool for JasperReports and JasperReports Server"
HOMEPAGE="http://community.jaspersoft.com/project/jaspersoft-studio"
SRC_URI="mirror://sourceforge/project/jasperstudio/JaspersoftStudio-${PV}/${MY_PN}_${PV}_linux_x86_64.tgz"
LICENSE="EPL-1.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=virtual/jre-1.8.0"

S="${WORKDIR}/${MY_PN}_${PV}"

src_install() {
	dodir /opt/"${PN}"
	cp -r "${S}"/* "${ED%/}"/opt/jaspersoft-studio/ || die "cp failed"
	dosym "${ED}"/opt/"${PN}"/"Jaspersoft Studio" /opt/bin/"${PN}"
	make_desktop_entry "/opt/bin/${PN}" "Jaspersoft Studio ${PV}" "/opt/${PN}/icon.xpm" "Development;"
	mv "${ED}"/usr/share/applications/*.desktop "${ED}"/usr/share/applications/"${PN}".desktop || die "mv failed"
}
