# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Automatically divides the screen area of i3wm windows on the longest side."
HOMEPAGE="https://github.com/deadc0de6/i3altlayout
	https://pypi.org/project/i3altlayout/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"

RDEPEND="dev-python/docopt[${PYTHON_USEDEP}]
	dev-python/i3ipc[${PYTHON_USEDEP}]"
DEPEND="${DEPEND}"
