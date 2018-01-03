# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_5 python3_6 )

inherit distutils-r1

DESCRIPTION="OWSLib is a Python package for client programming with Open Geospatial"
HOMEPAGE="http://geopython.github.io/OWSLib"
SRC_URI="https://github.com/geopython/${PN}/archive/${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"
RDEPEND="
	|| ( dev-python/lxml[${PYTHON_USEDEP}] dev-python/elementtree[${PYTHON_USEDEP}] )
"

S="${WORKDIR}/OWSLib-${PV}"
