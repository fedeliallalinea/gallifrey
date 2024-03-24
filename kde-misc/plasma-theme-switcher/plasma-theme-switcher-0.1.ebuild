# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A KDE Plasma theme switcher"
HOMEPAGE="https://github.com/maldoinc/plasma-theme-switcher"
SRC_URI="https://github.com/maldoinc/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	dev-qt/qtcore:5
	kde-frameworks/kconfig:5
"
RDEPEND="${DEPEND}"

src_install() {
	dobin "${BUILD_DIR}/plasma-theme"
}
