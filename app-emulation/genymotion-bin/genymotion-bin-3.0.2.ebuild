# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop bash-completion-r1 pax-utils

MY_PN="${PN/-bin}"
MY_P="${MY_PN}-${PV}"
BIN_ARCHIVE="${MY_P}-linux_x64.bin"

DESCRIPTION="Complete set of tools that provide a virtual environment for Android"
HOMEPAGE="https://genymotion.com"
SRC_URI="${BIN_ARCHIVE}"
DOWNLOAD_URL="https://www.genymotion.com/download/"

LICENSE="genymotion"
SLOT="0"
KEYWORDS="-* ~amd64"

DEPEND=""
RDEPEND="|| ( >=app-emulation/virtualbox-5.0.28 >=app-emulation/virtualbox-bin-5.0.28 )
	virtual/opengl
	|| (
		dev-libs/openssl:1.0.0
		=dev-libs/openssl-1.0*:0
	)
	dev-libs/hiredis:0=
	sys-apps/util-linux
"
BDEPEND=">=dev-util/patchelf-0.9_p20180129"

RESTRICT="binchecks bindist fetch"
S="${WORKDIR}"

pkg_nofetch() {
	einfo
	einfo "Please visit ${DOWNLOAD_URL} and download ${BIN_ARCHIVE}"
	einfo "which must be placed in DISTDIR directory."
	einfo
}

src_unpack() {
	cp "${DISTDIR}/${BIN_ARCHIVE}" "${WORKDIR}" || die "cp failed"
}

src_prepare() {
	default

	chmod +x ${BIN_ARCHIVE} || die "chmod failed"
	yes | ./${BIN_ARCHIVE} -d "${S}" > /dev/null || die "unpack failed"

	# removed windows line for bashcompletion
	sed -i "/complete -F _gmtool gmtool.exe/d" "${S}/${MY_PN}/completion/bash/gmtool.bash" || die "sed failed"

	# patch to support newer hiredis version (0.14)
	for i in genymotion genyshell gmtool player libcom.so.1.0.0 librendering.so.1.0.0 ; do
		patchelf --replace-needed libhiredis.so.0.13 libhiredis.so "${S}/${MY_PN}/$i" || die "Unable to patch $i for hiredis"
	done
}

src_install() {
	insinto /opt/"${MY_PN}"

	# Use qt bundled
	doins -r "${MY_PN}"/{geoservices,Qt,QtGraphicalEffects,QtLocation,QtPositioning,QtQuick,QtQuick.2}
	doins -r "${MY_PN}"/{icons,imageformats,platforms,plugins,sqldrivers,translations,xcbglintegrations}
	doins "${MY_PN}"/libQt*
	doins "${MY_PN}"/qt.conf
	doins "${MY_PN}"/libicu*

	doins "${MY_PN}"/{libcom,librendering}.so*
	# android library
	doins "${MY_PN}"/{libEGL_translator,libGLES_CM_translator,libGLES_V2_translator,libOpenglRender}.so*

	find "${ED%/}/opt/${MY_PN}" -name "*.so*" -type f -exec chmod +x {} \; || die "Change .so permission failed"

	exeinto /opt/"${MY_PN}"
	doexe "${MY_PN}"/{genymotion,genyshell,player,genymotionadbtunneld,gmtool}

	pax-mark -m "${ED%/}/opt/${MY_PN}/genymotion"
	pax-mark -m "${ED%/}/opt/${MY_PN}/gmtool"

	dosym ../"${MY_PN}"/genyshell /opt/bin/genyshell
	dosym ../"${MY_PN}"/genymotion /opt/bin/genymotion
	dosym ../"${MY_PN}"/gmtool /opt/bin/gmtool

	newbashcomp "${MY_PN}/completion/bash/gmtool.bash" gmtool

	insinto /usr/share/zsh/site-functions
	doins "${MY_PN}/completion/zsh/_gmtool"

	make_desktop_entry "/opt/${MY_PN}/${MY_PN}" "Genymotion ${PV}" "/opt/${MY_PN}/icons/icon.png" "Development;Emulator;"
}

pkg_postinst() {
	elog "Genymotion needs adb to work correctly: install with android-sdk-update-manager"
	elog "'Android SDK Platform-tools' and 'Android SDK Tools'"
	elog "Your user should also be in the android group to work correctly"
	elog "Then in Genymotion set the android-sdk-update-manager directory: (Settings->ADB)"
	elog
	elog "      /opt/android-sdk-update-manager"
}
