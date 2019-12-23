# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3 kde5-functions
	EGIT_REPO_URI="https://github.com/Zren/${PN}"
else
	inherit kde5-functions
	SRC_URI="https://github.com/Zren/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Plasma 5 applet that shows the application title and icon for active window"
HOMEPAGE="https://store.kde.org/p/998901/
	https://github.com/Zren/plasma-applet-eventcalendar"

LICENSE="GPL-2+"
IUSE=""
SLOT="0"

DEPEND="
	$(add_frameworks_dep kdeclarative)
	$(add_frameworks_dep plasma)
"
RDEPEND="${DEPEND}"

DOCS=( Changelog.md ReadMe.md )

src_install() {
	default
	insinto /usr/share/plasma/plasmoids/org.kde.plasma.eventcalendar
	doins package/metadata.desktop
	doins -r package/{contents,translate}
}
