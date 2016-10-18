# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit git-r3

DESCRIPTION="MBW determines the \"copy\" memory bandwidth available to userspace programs"
HOMEPAGE="https://github.com/raas/mbw"
EGIT_REPO_URI="https://github.com/raas/mbw.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_install() {
	exeinto /usr/bin
	doexe mbw || die
}
