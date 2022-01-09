# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop java-pkg-2

DESCRIPTION="yEd Graph Editor for generate high-quality drawings of diagrams."
HOMEPAGE="http://www.yworks.com/en/products_yed_about.html"
SRC_URI="yEd-${PV}.zip"
DOWNLOAD_URL="https://www.yworks.com/downloads"
MY_JAR="${P}.jar"

LICENSE="yEd"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="fetch"

RDEPEND="virtual/jre:1.8"
DEPEND="
	app-arch/unzip
	${RDEPEND}"

pkg_nofetch() {
	einfo "Please download the ${SRC_URI} from"
	einfo "${DOWNLOAD_URL}"
	einfo "and place it in distfiles directory"
}

src_unpack() {
	unzip "${DISTDIR}/${A}" || die "unpack failed"
}

src_install() {
	java-pkg_newjar ${PN}.jar
	java-pkg_dolauncher ${PN}
	for size in 16 24 32 48 64 128 ; do
		doicon icons/yed${size}.png
	done
	doicon icons/yed.ico
	make_desktop_entry ${PN} "yEd Graph Editor" yed "Graphics;2DGraphics"
	dodoc license.html
}
