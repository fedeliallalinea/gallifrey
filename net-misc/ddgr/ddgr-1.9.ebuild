# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="DuckDuckGo search from command line"
HOMEPAGE="https://github.com/jarun/ddgr"

if [[ ${PV} == 9999 ]];then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/jarun/${PN}"
else
	SRC_URI="https://github.com/jarun/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS=" ~amd64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"

src_install() {
	distutils-r1_src_install
	doman ddgr.1
}
