# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

FRAMEWORKS_MINIMAL="5.44.0"
#PLASMA_MINIMAL="5.12.0" not affects add_plasma_dep, bug?

inherit kde5 git-r3
EGIT_REPO_URI="https://anongit.kde.org/plasma-workspace.git"

DESCRIPTION="Proxy that allows to display GTK applications menus in Plasma global menu"
HOMEPAGE="https://www.kde.org/plasma-desktop"

LICENSE="GPL-2"
SLOT="0"

DEPEND="
	$(add_frameworks_dep extra-cmake-modules)
	$(add_frameworks_dep kdesignerplugin)
	$(add_frameworks_dep kdoctools)
	$(add_plasma_dep plasma-workspace '' '5.12.0')
"
RDEPEND="${DEPEND}
	x11-misc/vala-panel-appmenu
"

src_compile() {
	cmake-utils_src_compile -C gmenu-dbusmenu-proxy
}

src_install() {
	cmake-utils_src_install  -C gmenu-dbusmenu-proxy
}
