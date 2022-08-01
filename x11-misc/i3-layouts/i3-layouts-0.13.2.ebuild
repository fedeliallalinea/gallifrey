# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="Small program that enforces dynamic layout on i3 workspace."
HOMEPAGE="https://github.com/eliep/i3-layouts
	https://pypi.org/project/i3-layouts/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"

RDEPEND="dev-python/docopt[${PYTHON_USEDEP}]
	dev-python/i3ipc[${PYTHON_USEDEP}]
	x11-misc/xdotool"
DEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${PN}-exclude-install-test.patch")