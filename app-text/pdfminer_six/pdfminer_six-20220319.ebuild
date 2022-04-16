# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="${PN/_/.}"

PYTHON_COMPAT=( python3_{8..10} )

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3 distutils-r1
	EGIT_REPO_URI="https://github.com/pdfminer/${MY_PN}.git"
else
	inherit distutils-r1
	SRC_URI="https://github.com/pdfminer/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Python PDF Parser -- fork with Python 2+3 support using six"
HOMEPAGE="https://pdfminersix.readthedocs.io/en/latest/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
#IUSE="doc examples test"
IUSE="doc test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/tox[${PYTHON_USEDEP}]
		dev-python/mypy[${PYTHON_USEDEP}]
	)
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinx-argparse[${PYTHON_USEDEP}]
	)"
RDEPEND="
	dev-python/chardet[${PYTHON_USEDEP}]
	dev-python/cryptography[${PYTHON_USEDEP}]
	dev-python/pycryptodome[${PYTHON_USEDEP}]
	dev-python/sortedcontainers[${PYTHON_USEDEP}]
"

S="${WORKDIR}/${MY_PN}-${PV}"

distutils_enable_tests pytest
distutils_enable_sphinx docs/source

#python_compile_all(){
#	use examples && emake -C samples all
#}
