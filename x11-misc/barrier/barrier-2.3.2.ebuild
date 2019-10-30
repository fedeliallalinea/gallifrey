# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils desktop gnome2-utils

DESCRIPTION="Open-source KVM software based on Synergy"
HOMEPAGE="https://github.com/debauchee/barrier"
SRC_URI="https://github.com/debauchee/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="libressl qt5"
RESTRICT="test"

# avahi seems mandatory https://github.com/debauchee/barrier/issues/198
COMMON_DEPEND="
	!libressl? ( dev-libs/openssl:= )
	libressl? ( dev-libs/libressl:= )
	net-dns/avahi[mdnsresponder-compat]
	net-misc/curl
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXi
	x11-libs/libXinerama
	x11-libs/libXrandr
	x11-libs/libXtst
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtwidgets:5
		
		x11-themes/hicolor-icon-theme
	)
"

DEPEND="
	${COMMON_DEPEND}
	x11-base/xorg-proto
"
RDEPEND="
	${COMMON_DEPEND}
"

DOCS=( ChangeLog doc/barrier.conf.example{,-advanced,-basic} )

src_configure() {
	local mycmakeargs=(
		-DBARRIER_BUILD_GUI=$(usex qt5)
		-DBARRIER_REVISION=00000000
		-DBARRIER_BUILD_INSTALLER=OFF
	)

	cmake-utils_src_configure
}

src_install () {
	cmake-utils_src_install

	if use qt5 ; then
		newicon -s 256 "${S}"/res/${PN}.png ${PN}.png
		newmenu "${S}"/res/${PN}.desktop ${PN}.desktop
	fi

	insinto /etc
	newins doc/barrier.conf.example barrier.conf

	doman doc/${PN}c.1
	doman doc/${PN}s.1
}
