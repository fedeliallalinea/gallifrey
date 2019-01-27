# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit unpacker

MY_PN="${PN/-bin/}"

DESCRIPTION="A beautiful, fast and maintained fork of @nylas Mail."
HOMEPAGE="https://getmailspring.com/"
SRC_URI="https://github.com/Foundry376/Mailspring/releases/download/${PV}/${MY_PN}-${PV}-amd64.deb -> ${P}.deb"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="app-crypt/libsecret
	dev-libs/libgcrypt:0
	dev-libs/nss
	gnome-base/gconf
	gnome-base/gnome-keyring
	gnome-base/gvfs
	x11-misc/xdg-utils"
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}"

QA_PREBUILT="/opt/${PN}/*.so
	/opt/${PN}/resources/app.asar.unpacked/*.so*
	/opt/${PN}/resources/app.asar.unpacked/mailsync*
	/opt/${PN}/mailspring"

src_install() {
	insinto /usr/share/doc/${P}
	doins -r usr/share/doc/*
	
	insinto /opt/"${PN}"
	doins -r usr/share/mailspring/*
	insopts -m755
	doins usr/share/mailspring/{libEGL,libGLESv2,libVkICD_mock_icd,libffmpeg}.so
	doins usr/share/mailspring/mailspring

	exeinto /opt/"${PN}"/resources/app.asar.unpacked/
	doexe usr/share/mailspring/resources/app.asar.unpacked/mailsync
	doexe usr/share/mailspring/resources/app.asar.unpacked/mailsync.bin

	insinto /usr/share/application
	doins usr/share/applications/${MY_PN}.desktop

	insinto /usr/share/appdata
	doins usr/share/appdata/${MY_PN}.appdata.xml

	insinto /usr/share/pixmaps
	doins usr/share/pixmaps/${MY_PN}.png

	for SIZE in 16 32 64 128 256; do
		insinto /usr/share/icons/hicolor/${SIZE}x${SIZE}/apps
		doins usr/share/icons/hicolor/${SIZE}x${SIZE}/apps/${MY_PN}.png
	done

	dosym "${ED%/}"/opt/"${PN}"/${MY_PN} /opt/bin/${MY_PN}
}
