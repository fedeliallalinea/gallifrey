# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Console for the R program with multiline editing and rich syntax highlight"
HOMEPAGE="https://pypi.org/project/radian/
	https://github.com/randy3k/radian"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="test"

RDEPEND="
	dev-python/prompt-toolkit[${PYTHON_USEDEP}]
	dev-python/pygments[${PYTHON_USEDEP}]
	dev-python/rchitect[${PYTHON_USEDEP}]"
# BDEPEND="test? (
# 	dev-python/coverage[${PYTHON_USEDEP}]
# 	dev-python/pexpect[${PYTHON_USEDEP}]
# 	dev-python/pyte[${PYTHON_USEDEP}]
# )"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

#distutils_enable_tests pytest
