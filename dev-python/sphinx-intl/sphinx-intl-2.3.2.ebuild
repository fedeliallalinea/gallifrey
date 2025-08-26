# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )
inherit distutils-r1 pypi

DESCRIPTION="Utility tool to translate Sphinx generated document."
HOMEPAGE="https://github.com/sphinx-doc/sphinx-intl https://pypi.org/project/sphinx-intl/"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"
# use tox that seems not supported in distutils-r1 eclass
RESTRICT="test"

RDEPEND="dev-python/babel[${PYTHON_USEDEP}]
	dev-python/click[${PYTHON_USEDEP}]
	dev-python/sphinx[${PYTHON_USEDEP}]
"
BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]"
