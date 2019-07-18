# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="Display and control your Android device"
HOMEPAGE="https://github.com/Genymobile/scrcpy"
SRC_URI="https://github.com/Genymobile/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/Genymobile/${PN}/releases/download/v${PV}/${PN}-server-v${PV}.jar -> ${PN}-server-${PV}.jar"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	media-libs/libsdl2
	media-video/ffmpeg
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-spelling.patch
)

src_configure() {
	local emesonargs=(
		-D build_server=false
		-D portable=false
	)

	meson_src_configure
}

src_install() {
	meson_src_install

	insinto /usr/share/${PN}
	newins ${DISTDIR}/${PN}-server-${PV}.jar ${PN}-server.jar
}
