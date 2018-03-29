# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

FRAMEWORKS_MINIMAL="5.44.0"
#PLASMA_MINIMAL="5.12.0" not affects add_plasma_dep, bug?

inherit kde5 git-r3
EGIT_REPO_URI="https://anongit.kde.org/plasma-workspace.git"
# not depending on frameworks 5.45
EGIT_COMMIT="e37156b404bffd4dc6fd0d1b2dbb5dc1ae0ddfa4"

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
	>=dev-libs/libdbusmenu-16.04.0
	x11-misc/vala-panel-appmenu
"

PATCHES=( "${FILESDIR}/revert-plasma_install_bundled_package.patch" )

src_configure() {
        local mycmakeargs=(
                -DCMAKE_DISABLE_FIND_PACKAGE_AppStreamQt=OFF
                -DCMAKE_DISABLE_FIND_PACKAGE_KF5Holidays=OFF
                -DCMAKE_DISABLE_FIND_PACKAGE_KF5NetworkManagerQt=OFF
                -DCMAKE_DISABLE_FIND_PACKAGE_KF5Prison=OFF
                -DCMAKE_DISABLE_FIND_PACKAGE_alculate=OFF
                -DCMAKE_DISABLE_FIND_PACKAGE_F5Baloo=OFF
        )

        kde5_src_configure
}

src_compile() {
	cmake-utils_src_compile -C gmenu-dbusmenu-proxy
}

src_install() {
	cmake-utils_src_install  -C gmenu-dbusmenu-proxy
}
