# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_6} )
PYTHON_REQ_USE="ncurses"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3 distutils-r1
	EGIT_REPO_URI="https://github.com/amanusk/${PN}.git"
else
	inherit distutils-r1
	SRC_URI="https://github.com/amanusk/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Stress-Terminal UI monitoring tool"
HOMEPAGE="https://amanusk.github.io/s-tui"

LICENSE="GPL-2"
SLOT="0"
IUSE="stress"

RDEPEND="
	dev-python/urwid[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	stress? ( app-benchmarks/stress )
"

DEPEND="${RDEPEND}"

BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"
