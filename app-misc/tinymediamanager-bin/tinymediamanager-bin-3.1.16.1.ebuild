# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop java-pkg-2

MY_PN="${PN/-bin}"

DESCRIPTION="tinyMediaManager is a media management tool written in Java/Swing"
HOMEPAGE="https://www.tinymediamanager.org/"
SRC_URI="https://release.tinymediamanager.org/v3/dist/tmm_${PV}_linux.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="media-video/mediainfo
	>=virtual/jre-1.8:*"

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
