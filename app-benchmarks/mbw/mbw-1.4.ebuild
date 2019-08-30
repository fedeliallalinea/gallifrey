# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="MBW determines the \"copy\" memory bandwidth available to userspace programs"
HOMEPAGE="https://github.com/raas/mbw"
SRC_URI="https://github.com/raas/mbw/releases/download/v${PV}/mbw-${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/${PN}"

src_install() {
	dobin mbw
}
