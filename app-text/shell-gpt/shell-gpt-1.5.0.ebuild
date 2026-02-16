# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
DISTUTILS_USE_PEP517=standalone
inherit distutils-r1 pypi

MY_PN="${PN/-/_}"

DESCRIPTION="A command-line interface productivity tool powered by OpenAI's Davinci mode"
HOMEPAGE="https://pypi.org/project/shell-gpt/ https://github.com/ther1d/shell_gpt"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="MIT BSD"
SLOT="0"
KEYWORDS="~amd64"
# test need key api to run
RESTRICT="test"

RDEPEND="dev-python/click[${PYTHON_USEDEP}]
	dev-python/distro[${PYTHON_USEDEP}]
	dev-python/openai[${PYTHON_USEDEP}]
	dev-python/prompt-toolkit[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/rich[${PYTHON_USEDEP}]
	dev-python/typer[${PYTHON_USEDEP}]"

PATCHES=(
	"${FILESDIR}/${PN}-1.4.4_tool-calls-none.patch"
)
