# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..9} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

MY_PV=${PV/_p1/.post1}

DESCRIPTION="It converts distutils2's setup.cfg to setuptools' setup.py"
HOMEPAGE="https://github.com/embray/d2to1"
SRC_URI="https://github.com/embray/${PN}/archive/refs/tags/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

distutils_enable_tests nose

S="${WORKDIR}/${PN}-${MY_PV}"
