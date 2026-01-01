# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Python client library for the OpenAI API"
HOMEPAGE="https://github.com/openai/openai-python"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="datalib realtime"
# Require to set up a mock server
# https://github.com/openai/openai-python/blob/main/CONTRIBUTING.md
RESTRICT="test"

RDEPEND="
	dev-python/anyio[${PYTHON_USEDEP}]
	dev-python/distro[${PYTHON_USEDEP}]
	dev-python/h2[${PYTHON_USEDEP}]
	dev-python/httpx[${PYTHON_USEDEP}]
	dev-python/jiter[${PYTHON_USEDEP}]
	dev-python/pydantic[${PYTHON_USEDEP}]
	dev-python/sniffio[${PYTHON_USEDEP}]
	dev-python/tqdm[${PYTHON_USEDEP}]
	dev-python/typing-extensions[${PYTHON_USEDEP}]
	datalib? (
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
	)
	realtime? (
		dev-python/websockets[${PYTHON_USEDEP}]
	)"
#	wandb? ( dev-python/wandb[$PYTHON_USEDEP}] )"
# BDEPEND="test? (
# 	dev-python/anyio[${PYTHON_USEDEP}]
# 	dev-python/inline-snapshot[${PYTHON_USEDEP}]
# 	dev-python/pytest-asyncio[${PYTHON_USEDEP}]
# 	dev-python/pytest-mock[${PYTHON_USEDEP}]
# 	dev-python/pytest-xdist[${PYTHON_USEDEP}]
# 	dev-python/respx[${PYTHON_USEDEP}]
# )"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
#		wandb? ( datalib )"

#distutils_enable_tests pytest
