# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Wireless Display Software"
HOMEPAGE="https://github.com/intel/wds"
SRC_URI="https://github.com/intel/${PN}/archive/v${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="test"

DEPEND="dev-util/patchelf"
RDEPEND=">=net-wireless/wpa_supplicant-2.4[dbus,p2p]
	>=net-misc/connman-1.28
	media-libs/gstreamer:1.0"

DOCS=( COPYING README.md TODO )

src_install() {
	cmake-utils_src_install

	if use test ; then
		patchelf --set-rpath '$ORIGIN' "${BUILD_DIR}/desktop_source/desktop-source-test"
		dobin "${BUILD_DIR}/desktop_source/desktop-source-test"
		patchelf --set-rpath '$ORIGIN' "${BUILD_DIR}/sink/sink-test"
		dobin "${BUILD_DIR}/sink/sink-test"
	fi
}
