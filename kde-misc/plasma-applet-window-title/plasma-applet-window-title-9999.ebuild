# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN/plasma-/}"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3 kde5-functions
	EGIT_REPO_URI="https://github.com/psifidotos/${MY_PN}"
else
	inherit kde5-functions
	SRC_URI="https://github.com/psifidotos/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_PN}-${PV}"
fi

DESCRIPTION="Plasma 5 applet that shows the application title and icon for active window"
HOMEPAGE="https://github.com/psifidotos/applet-window-title"

LICENSE="GPL-2+"
IUSE=""
SLOT="0"

DEPEND="
	$(add_frameworks_dep kdeclarative)
	$(add_frameworks_dep plasma)
"
RDEPEND="${DEPEND}"

DOCS=( CHANGELOG.md LICENSE README.md )

src_install() {
	default
	insinto /usr/share/plasma/plasmoids/org.kde.windowtitle
	doins metadata.desktop
	doins -r contents
}	
