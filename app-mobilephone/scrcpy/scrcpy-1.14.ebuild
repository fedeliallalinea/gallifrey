# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="Display and control your Android device"
HOMEPAGE="https://github.com/Genymobile/scrcpy"
SRC_URI="https://github.com/Genymobile/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/Genymobile/${PN}/releases/download/v${PV}/${PN}-server-v${PV} -> ${PN}-server-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	media-libs/libsdl2
	media-video/ffmpeg
"
RDEPEND="${DEPEND}"

src_configure() {
	local emesonargs=(
		-Db_lto=true
		-Dprebuilt_server="${DISTDIR}/${PN}-server-${PV}"
	)
	meson_src_configure
}

pkg_postinst() {
	elog "scrcpy needs adb to work correctly: install with android-sdk-update-manager"
	elog "'Android SDK Platform-tools' and 'Android SDK Tools'"
	elog "Your user should also be in the android group to work correctly"
}
