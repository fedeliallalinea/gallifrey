# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop java-pkg-2

MY_PN="${PN/-bin}"

DESCRIPTION="Media manager to provide metadata for the Kodi Media Center"
HOMEPAGE="https://www.tinymediamanager.org/"
SRC_URI="https://release.tinymediamanager.org/v5/dist/tinyMediaManager-${PV}-linux-amd64.tar.xz -> ${P}.tar.xz"
S="${WORKDIR}/tinyMediaManager"

LICENSE="Apache-2.0"
SLOT="0/5"
KEYWORDS="~amd64"

RDEPEND="media-video/mediainfo
	>=virtual/jre-11:*"

src_install() {
	insinto /usr/share/tinymediamanager-bin
	doicon tmm.png tmm.ico
	doins -r templates

	java-pkg_dojar lib/*.jar tmm.jar restart.jar
	java-pkg_dolauncher "${MY_PN}" \
		--main org.tinymediamanager.TinyMediaManager \
		--java_args '-Xms64m \
			-Xmx512m \
			-Xss512k \
			-XX:+IgnoreUnrecognizedVMOptions \
			-XX:+UseG1GC \
			-XX:+UseStringDeduplication \
			-Dsun.java2d.renderer=sun.java2d.marlin.MarlinRenderingEngine \
			-Djava.net.preferIPv4Stack=true \
			-Dfile.encoding=UTF-8 \
			-Dsun.jnu.encoding=UTF-8 \
			-Djna.nosys=true \
			-Dtmm.consoleloglevel=OFF \
			-Dawt.useSystemAAFontSettings=on \
			-Dswing.aatext=true \
			-Dtmm.contentfolder="${HOME}"/.tmm'
	java-pkg_dolauncher "${MY_PN}-cli" \
		--main org.tinymediamanager.TinyMediaManager \
		--java_args '-Xms64m \
			-Xmx512m \
			-Xss512k \
			-XX:+IgnoreUnrecognizedVMOptions \
			-XX:+UseG1GC \
			-XX:+UseStringDeduplication \
			-Djava.awt.headless=true \
			-Djava.net.preferIPv4Stack=true \
			-Dfile.encoding=UTF-8 \
			-Dsun.jnu.encoding=UTF-8 \
			-Djna.nosys=true \
			-Dtmm.consoleloglevel=OFF \
			-Dtmm.contentfolder="${HOME}"/.tmm'

	make_desktop_entry "${MY_PN}" "tinyMediaManager ${PV}" "/usr/share/pixmaps/tmm.png" "AudioVideo;Video;Database;Java;"
}

pkg_postinst() {
	elog
	elog "This is a FREE version of tinyMediaManager, if you want to unlock all features"
	elog "you need to buy a license for the PRO version. The key differences are listed"
	elog "at https://www.tinymediamanager.org/purchase/."
	elog
}
