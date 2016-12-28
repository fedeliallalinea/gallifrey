# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils bash-completion-r1

DESCRIPTION="Complete set of tools that provide a virtual environment for Android"
HOMEPAGE="http://genymotion.com"
SRC_URI="https://www.genymotion.com/download-handler/?opt=ubu_first_64_download_link -> ${P}_x64.bin"

LICENSE="genymotion"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="|| ( >=app-emulation/virtualbox-5.0.28 >=app-emulation/virtualbox-bin-5.0.28 )
	virtual/opengl
	media-libs/libpng:1.2
	dev-libs/openssl
	dev-qt/qtgui:5[libinput,xcb]
	dev-qt/qtsql:5[sqlite]
	dev-util/android-sdk-update-manager
	media-libs/jpeg:8
	dev-libs/protobuf:0/9
	dev-libs/double-conversion
	sys-apps/util-linux
	media-libs/fontconfig:1.0
	media-libs/harfbuzz[graphite]
	>=dev-libs/libffi-3.0.13-r1
	media-libs/gstreamer[orc]
"

pkg_setup() {
	cd "${DISTDIR}"
	# removed function _install_desktop_file because happens outside of sandbox
	sed -i -e "s/_install_desktop_file\ ||\ abort//" ${A}
	fperms +x ${A}
}

src_unpack() {
	cd "${DISTDIR}"
	yes | ./${A} -d "${S}" > /dev/null
}

src_prepare() {
	# removed windows line for bashcompletion
	sed -i -e "s/complete\ -F\ _gmtool\ gmtool.exe//" "${S}/${PN}/completion/bash/gmtool.bash"
	default
}

QA_PREBUILT="
	opt/${PN}/*.so*
	opt/${PN}/imageformats/*.so
	opt/${PN}/plugins/*.so*
	opt/${PN}/device-upgrade
	opt/${PN}/${PN}
	opt/${PN}/genyshell
	opt/${PN}/player
	opt/${PN}/${PN}adbtunneld
	opt/${PN}/gmtool
"

src_install() {
	local DEST=/opt/"${PN}"
	insinto "${DEST}"
	doins -r "${PN}"/{plugins,translations,icons}

	doins "${PN}"/{libcom,librendering}.so*
	# library that differ from system version
	doins "${PN}"/{libicudata,libicui18n,libicuuc,libswscale,libavutil}.so*
	# android library
	doins "${PN}"/{libEGL_translator,libGLES_CM_translator,libGLES_V2_translator,libOpenglRender}.so*

	insopts -m0755
	doins "${PN}"/{device-upgrade,genymotion,genyshell,player,genymotionadbtunneld,gmtool}

	dosym "${DEST}"/genyshell /opt/bin/genyshell
	dosym "${DEST}"/"${PN}" /opt/bin/"${PN}"
	dosym "${DEST}"/device-upgrade /opt/bin/"${PN}"-device-upgrade
	dosym "${DEST}"/player /opt/bin/"${PN}"-player
	dosym "${DEST}"/"${PN}"adbtunneld /opt/bin/"${PN}"adbtunneld
	dosym "${DEST}"/gmtool /opt/bin/gmtool

	# Workaround
	dosym /usr/$(get_libdir)/qt5/plugins/imageformats/libqsvg.so "${DEST}"/imageformats/libqsvg.so

	newbashcomp "${PN}/completion/bash/gmtool.bash" gmtool

	make_desktop_entry "${DEST}/${PN}" "Genymotion ${PV}" "${DEST}/icons/icon.png" "Development;Emulator;"
	mv "${D}usr/share/applications"/*.desktop "${D}usr/share/applications/${PN}.desktop"
}
