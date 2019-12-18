# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN/plasma-/}"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3 kde5
	EGIT_REPO_URI="https://github.com/psifidotos/${MY_PN}"
else
	inherit kde5
	SRC_URI="https://github.com/psifidotos/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_PN}-${PV}"
fi

DESCRIPTION="Plasma 5 applet in order to show window buttons in your panels"
HOMEPAGE="https://github.com/psifidotos/applet-window-buttons"

LICENSE="GPL-2+"
IUSE=""

DEPEND="
	$(add_frameworks_dep extra-cmake-modules)
	$(add_frameworks_dep kdeclarative)
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep plasma)
	$(add_plasma_dep kdecoration)
"
RDEPEND="${DEPEND}"
