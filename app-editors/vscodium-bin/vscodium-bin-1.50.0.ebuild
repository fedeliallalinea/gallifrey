# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop pax-utils xdg-utils

MY_PN="${PN/-bin}"

DESCRIPTION="Free/Libre Open Source Software Binaries of VSCode (binary version)"
HOMEPAGE="https://vscodium.com"

SRC_URI="
	amd64? ( https://github.com/VSCodium/vscodium/releases/download/${PV}/VSCodium-linux-x64-${PV}.tar.gz )
	arm64? ( https://github.com/VSCodium/vscodium/releases/download/${PV}/VSCodium-linux-arm64-${PV}.tar.gz )"

RESTRICT="mirror strip bindist"

LICENSE="MIT"
SLOT="0"
KEYWORDS="-* ~amd64 ~arm64"
IUSE=""

DEPEND="
	media-libs/libpng
	x11-libs/cairo
	x11-libs/gtk+:3
	x11-libs/libXtst"

RDEPEND="
	${DEPEND}
	app-accessibility/at-spi2-atk
	dev-libs/nss
	>=net-print/cups-2.0.0
	x11-libs/libnotify
	x11-libs/libXScrnSaver
	app-crypt/libsecret[crypt]"

QA_PRESTRIPPED="*"
QA_PREBUILT="opt/${MY_PN}/codium"

S="${WORKDIR}"

src_install() {
	dodir /opt/${MY_PN}
	cp -r . "${ED%/}/opt/${MY_PN}/" || die
	dosym ../../opt/${MY_PN}/bin/codium /opt/bin/${MY_PN}
	dosym ../../opt/${MY_PN}/bin/codium /opt/bin/codium
	domenu "${FILESDIR}/${PN}.desktop"
	newicon "resources/app/resources/linux/code.png" ${MY_PN}.png
	pax-mark m "${ED}/opt/${MY_PN}/codium"
}

pkg_postinst() {
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
