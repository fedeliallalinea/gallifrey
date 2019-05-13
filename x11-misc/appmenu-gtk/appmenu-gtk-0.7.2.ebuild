# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils gnome2-utils

DESCRIPTION="Application menu module for GTK"
HOMEPAGE="https://github.com/rilian-la-te/vala-panel-appmenu"
SRC_URI="https://gitlab.com/vala-panel-project/vala-panel-appmenu/uploads/06abbf1c99af59b95efcb0f149bc5a10/${PN}-module-${PV}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk2"

DEPEND=">=dev-libs/glib-2.50[dbus]
	>=x11-libs/gtk+-3.22.0:3
	gtk2? ( >=x11-libs/gtk+-2.24.0:2 )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-gtk2-cmake.patch"
)

S="${WORKDIR}/${PN}-module-${PV}"

src_configure() {
	local mycmakeargs=(
		-DGSETTINGS_COMPILE=OFF
		-DENABLE_GTK2=$(usex gtk2)
	)

	cmake-utils_src_configure
}

src_install () {
	cmake-utils_src_install
	exeinto /etc/X11/xinit/xinitrc.d
	newexe "${FILESDIR}"/appmenu-gtk-module.sh 80-appmenu-gtk-module
}

pkg_postinst() {
	gnome2_schemas_update
}
