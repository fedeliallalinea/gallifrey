# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit unpacker user

MY_PN=${PN/-bin/}

DESCRIPTION="Network Audio Daemon"
HOMEPAGE="http://www.signalyst.com/consumer.html"
SRC_URI="
	amd64? ( https://www.signalyst.eu/bins/naa/linux/stretch/${MY_PN}_${PV}-32_amd64.deb )
	x86?   ( https://www.signalyst.eu/bins/naa/linux/stretch/${MY_PN}_${PV}-32_i386.deb )
"

LICENSE="Signalyst"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror bindist"

RDEPEND=">=sys-devel/gcc-5.1.0[openmp]
	>=media-libs/alsa-lib-1.0.16"

DEPEND="${RDEPEND}"

S="${WORKDIR}"
QA_PREBUILT="usr/sbin/networkaudiod"

pkg_setup() {
	enewgroup networkaudiod
	enewuser networkaudiod -1 -1 "/dev/null" "networkaudiod,audio"
}

src_unpack() {
	unpack_deb ${A}
}

src_install() {
	mv usr etc lib "${D}" || die
	rm "${D}usr/share/doc/networkaudiod/changelog.Debian.gz"        
	newinitd "${FILESDIR}/${MY_PN}.init.d" "${MY_PN}"
}
