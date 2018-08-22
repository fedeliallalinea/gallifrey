# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 kde5

DESCRIPTION="Guitarist helper program focusing on tabulature editing and MIDI synthesizers support"
HOMEPAGE="http://kguitar.sf.net/"
EGIT_REPO_URI="https://github.com/pavelliavonau/${PN}.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="midi"

DEPEND="
        $(add_frameworks_dep kconfig)
        $(add_frameworks_dep kdoctools)
        $(add_frameworks_dep ki18n)
        $(add_frameworks_dep kparts)
        $(add_qt_dep qtgui)
        $(add_qt_dep qtwidgets)
        $(add_qt_dep qtxml)
        midi? ( >=media-libs/tse3-0.3.0 )
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/kguitar-qheaderview.patch" )

src_configure() {
	local mycmakeargs=( -DWITH_TSE3="$(usex midi)" )
	kde5_src_configure
}
