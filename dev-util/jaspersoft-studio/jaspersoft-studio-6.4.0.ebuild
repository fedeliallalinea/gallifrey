# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
inherit eutils

MY_PN="TIB_js-studiocomm"

DESCRIPTION="Eclipse-based report development tool for JasperReports and JasperReports Server"
HOMEPAGE="http://community.jaspersoft.com/project/jaspersoft-studio"
SRC_URI="amd64? ( mirror://sourceforge/project/jasperstudio/JaspersoftStudio-${PV}/${MY_PN}_${PV}_linux_x86_64.tgz )
	x86? ( mirror://sourceforge/project/jasperstudio/JaspersoftStudio-${PV}/${MY_PN}_${PV}_linux_x86.tgz )"
LICENSE="EPL-1.0"
IUSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=virtual/jre-1.8.0"

RDEPEND=""

S="${WORKDIR}/${MY_PN}_${PV}"

src_install() {
	dodir /opt/"${PN}"
	cp -r "${S}"/* "${ED%/}"/opt/jaspersoft-studio/ || die "cp failed"
	dosym "${ED%/}"/opt/"${PN}"/"Jaspersoft Studio" /opt/bin/"${PN}"
	make_desktop_entry "/opt/bin/${PN}" "Jaspersoft Studio ${PV}" "/opt/${PN}/icon.xpm" "Development;"
	mv "${ED%/}"/usr/share/applications/*.desktop "${ED%/}"/usr/share/applications/"${PN}".desktop || die "mv failed"
}
