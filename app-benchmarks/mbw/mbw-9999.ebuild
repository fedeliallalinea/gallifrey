# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="MBW determines the \"copy\" memory bandwidth available to userspace programs"
HOMEPAGE="https://github.com/raas/mbw"
EGIT_REPO_URI="https://github.com/raas/mbw.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_install() {
	dobin mbw
}
