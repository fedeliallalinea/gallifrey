# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

_PN="${PN/-bin/}"

inherit desktop unpacker xdg-utils

DESCRIPTION="Combine your favorite messaging services into one application"
HOMEPAGE="https://ferdium.org/"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="wayland"
KEYWORDS="~amd64"
SRC_URI="https://github.com/${_PN}/${_PN}-app/releases/download/v${PV}/${_PN^}-linux-${PV}-amd64.deb"

RDEPEND="
	wayland? ( dev-libs/wayland )"

S=${WORKDIR}

QA_PREBUILT="
	opt/Ferdium/chrome-sandbox
	opt/Ferdium/libEGL.so
	opt/Ferdium/chrome_crashpad_handler
	opt/Ferdium/libffmpeg.so
	opt/Ferdium/libvk_swiftshader.so
	opt/Ferdium/libGLESv2.so
	opt/Ferdium/ferdium
	opt/Ferdium/libvulkan.so.1"

src_prepare() {
	default

	if use wayland; then
		sed -E -i -e "s|Exec=/opt/${_PN^}/${_PN}|Exec=/usr/bin/${PN} --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-webrtc-pipewire-capturer|" "usr/share/applications/${_PN}.desktop"
	else
		sed -E -i -e "s|Exec=/opt/${_PN^}/${_PN}|Exec=/usr/bin/${PN}|" "usr/share/applications/${_PN}.desktop"
	fi
}

src_install() {
	local FERDIUM_HOME=/opt/${_PN^}

	insinto ${FERDIUM_HOME}
	doins -r opt/${_PN^}/*

	exeinto ${FERDIUM_HOME}
	doexe "opt/${_PN^}/${_PN}"

	# keep executable portable library
	doexe opt/${_PN^}/{chrome-sandbox,chrome_crashpad_handler,lib*}

	dosym "${FERDIUM_HOME}/${_PN}" "/usr/bin/${PN}"

	newmenu usr/share/applications/${_PN}.desktop ${PN}.desktop

	for _size in 16 24 32 48 64 96 128 256 512; do
		newicon -s ${_size} "usr/share/icons/hicolor/${_size}x${_size}/apps/${_PN}.png" "${_PN}.png"
	done
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
