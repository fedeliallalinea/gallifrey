# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

MY_PN="${PN/-/_}"

DESCRIPTION="A command-line interface (CLI) productivity tool powered by OpenAI's Davinci mode"
HOMEPAGE="https://pypi.org/project/shell-gpt/ https://github.com/ther1d/shell_gpt"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${MY_PN}-${PV}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="MIT BSD"
SLOT="0"
KEYWORDS="~amd64"
# test need key api to run
RESTRICT="test"

RDEPEND="dev-python/distro[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	>=dev-python/rich-13.3.1[${PYTHON_USEDEP}]
	>=dev-python/typer-0.7.0[${PYTHON_USEDEP}]"

src_prepare() {
	default
	rm -r tests || die
}
