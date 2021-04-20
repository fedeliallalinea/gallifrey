# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop

DESCRIPTION="A healthy, bite-sized window manager written over the XLib Library"
HOMEPAGE="https://berrywm.org/
	https://github.com/JLErvin/berry"
SRC_URI="https://github.com/JLErvin/${PN}/archive/refs/tags/${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="x11-libs/libX11
	x11-libs/libXft
	x11-libs/libXinerama"
RDEPEND="${DEPEND}"

src_install() {
	emake DESTDIR="${D}" PREFIX="/usr" MANPREFIX="/usr/share/" install

	insinto /etc/xdg/berry/
	doins examples/*

	domenu "${FILESDIR}"/berry.desktop
}
