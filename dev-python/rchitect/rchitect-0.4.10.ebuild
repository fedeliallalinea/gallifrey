# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Python interface to the R language"
HOMEPAGE="https://pypi.org/project/rchitect/
	https://github.com/randy3k/rchitect"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"

RDEPEND="
	dev-python/cffi[${PYTHON_USEDEP}]"
# BDEPEND="test? (
# 	dev-python/pytest-mock[${PYTHON_USEDEP}]
# 	dev-python/pytest-cov[${PYTHON_USEDEP}]
# )"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

#distutils_enable_tests pytest
