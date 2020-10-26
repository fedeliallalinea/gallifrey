# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop java-pkg-2

MY_PN="${PN/-bin}"

DESCRIPTION="tinyMediaManager is a media management tool written in Java/Swing"
HOMEPAGE="https://www.tinymediamanager.org/"
SRC_URI="https://release.tinymediamanager.org/v4/dist/tmm_${PV}_linux.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="media-video/mediainfo
	>=virtual/jre-11:*"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_install() {
	insinto /usr/share/tinymediamanager-bin
	doins splashscreen.png
	doicon tmm.png

	java-pkg_dojar lib/*.jar tmm.jar
	java-pkg_dolauncher "${MY_PN}" \
		--main org.tinymediamanager.TinyMediaManager \
		--java_args '-Djava.net.preferIPv4Stack=true \
			-Dappbase=http://www.tinymediamanager.org/ \
			-Dtmm.contentfolder="${HOME}"/.tmm \
			-Dtmm.noupdate=true \
			-splash:/usr/share/tinymediamanager-bin/splashscreen.png'
	java-pkg_dolauncher "${MY_PN}-cli" \
		--main org.tinymediamanager.TinyMediaManager \
		--java_args '-Djava.net.preferIPv4Stack=true \
            -Dappbase=http://www.tinymediamanager.org/ \
			-Djna.nosys=true \
			-Djava.awt.headless=true \
            -Dtmm.contentfolder="${HOME}"/.tmm \
            -Dtmm.noupdate=true \
			-Xms64m \
			-Xmx512m \
			-Xss512k'

	make_desktop_entry "${MY_PN}" "tinyMediaManager ${PV}" "/usr/share/pixmaps/tmm.png" "AudioVideo;Video;Database;Java;"
}

pkg_postinst() {
	elog
	elog "From version 4 tinyMediaManager remains open source and the code remains free"
	elog "but with some limitations, currently 50 movies, 10 TV series and about 50 API"
	elog "calls."
	elog
	elog "These limitations can be unlocked buying a license at"
	elog
	elog "  https://www.tinymediamanager.org/purchase/"
	elog
	elog "After you have received your license code just paste the license code without"
	elog "any extra spaces/newlines into a file called \${HOME}/.tmm/data/tmm.lic"
	elog
}
