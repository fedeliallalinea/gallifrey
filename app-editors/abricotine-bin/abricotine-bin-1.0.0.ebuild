# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop unpacker xdg

MY_PN="${PN/-bin/}"

DESCRIPTION="A markdown editor with inline preview"
HOMEPAGE="https://abricotine.brrd.fr https://github.com/brrd/abricotine"
SRC_URI="amd64? ( https://github.com/brrd/${MY_PN}/releases/download/${PV}/${MY_PN}-${PV}-ubuntu-debian-x64.deb )
	x86? ( https://github.com/brrd/${MY_PN}/releases/download/${PV}/${MY_PN}-${PV}-ubuntu-debian-ia32.deb )"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="app-accessibility/at-spi2-core
	dev-libs/nss
	x11-libs/gtk+:3
	x11-misc/xdg-utils
	|| (
		app-misc/trash-cli
		dev-libs/glib
		gnome-base/gvfs
		kde-plasma/kde-cli-tools
	)"

S="${WORKDIR}"

QA_PREBUILT="
	opt/abricotine/*.so
	opt/abricotine/abricotine
	opt/abricotine/swiftshader/*.so
"

src_install() {
	insinto /opt/abricotine
	doins -r usr/lib/abricotine/.

	exeinto /opt/abricotine
	doexe usr/lib/abricotine/{abricotine,chrome-sandbox,libEGL.so,libGLESv2.so,libffmpeg.so}
	exeinto /opt/abricotine/swiftshader
	doexe usr/lib/abricotine/swiftshader/{libEGL.so,libGLESv2.so}

	for size in 48 64 128 256; do
		doicon -s ${size} usr/share/icons/hicolor/${size}x${size}/apps/. 
	done

	dosym ../../opt/abricotine/abricotine /usr/bin/abricotine

	domenu usr/share/applications/abricotine.desktop
}

pkg_postinst() {
	xdg_pkg_postinst
}

pkg_postrm() {
	xdg_pkg_postrm
}
