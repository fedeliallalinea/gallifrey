# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

DESCRIPTION="Quickly change plasma color schemes and widget styles from the command-line"
HOMEPAGE="https://github.com/maldoinc/plasma-theme-switcher"
SRC_URI="https://github.com/maldoinc/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	dev-qt/qtcore:5
	kde-frameworks/kconfig
"
RDEPEND="${DEPEND}"

src_install() {
	dobin ${BUILD_DIR}/plasma-theme
	dodoc README.MD
}
