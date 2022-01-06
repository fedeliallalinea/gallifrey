# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

if [[ ${PV} == *9999 ]];then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/tobi-wan-kenobi/bumblebee-status"
else
	SRC_URI="https://github.com/tobi-wan-kenobi/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Modular, theme-able status line generator for the i3 window manager"
HOMEPAGE="https://github.com/tobi-wan-kenobi/bumblebee-status"

LICENSE="MIT"
SLOT="0"

RDEPEND="
	dev-python/netifaces[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		dev-python/freezegun[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

pkg_postinst() {
	elog
	elog "The bumblebee-status was installed with minimal dependencies,"
	elog "many modules require other dependencies to work."
	elog "To understand what dependencies a module needs please consult"
	elog "the documentation:"
	elog
	elog "    https://bumblebee-status.readthedocs.io/en/main/modules.html"
	elog
}
