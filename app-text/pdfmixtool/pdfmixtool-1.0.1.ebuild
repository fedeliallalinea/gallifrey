# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg-utils

DESCRIPTION="Application to split, merge, rotate and mix PDF files"
HOMEPAGE="https://scarpetta.eu/pdfmixtool"
SRC_URI="https://gitlab.com/scarpetta/${PN}/-/archive/v${PV}/${PN}-v${PV}.tar.gz"
KEYWORDS="~amd64"

LICENSE="GPL-3"
SLOT="0"

DEPEND="
	app-text/podofo:=
	>=app-text/qpdf-10.0.0:=
	dev-qt/qtcore:5
	dev-qt/qtwidgets:5"
RDEPEND="${DEPEND}"
BDEPEND="dev-qt/linguist-tools:5"

S="${WORKDIR}/${PN}-v${PV}"

pkg_postinst() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_icon_cache_update
	xdg_desktop_database_update
}
