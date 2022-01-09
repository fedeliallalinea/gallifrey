# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_SETUPTOOLS=bdepend

inherit distutils-r1

DESCRIPTION="rawkit is a ctypes-based set of LibRaw bindings for Python"
HOMEPAGE="https://rawkit.readthedocs.io/en/latest/ https://github.com/photoshell/rawkit"
SRC_URI="https://github.com/photoshell/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
