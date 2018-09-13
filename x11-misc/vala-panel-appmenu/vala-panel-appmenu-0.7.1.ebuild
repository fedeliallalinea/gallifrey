# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/lxde-base/lxpanel/lxpanel-0.7.0-r1.ebuild,v 1.1 2014/09/10 01:54:45 nullishzero Exp $

EAPI=6

inherit cmake-utils git-r3 gnome2-utils vala
EGIT_REPO_URI="https://gitlab.com/vala-panel-project/${PN}.git"

if [[ ${PV} == "9999" ]] ; then
	KEYWORDS=""
else
	KEYWORDS="~amd64 ~x86"
	EGIT_COMMIT="${PV}"
fi

VALA_MIN_API_VERSION="0.34"

DESCRIPTION="Global Menu plugin"
HOMEPAGE="https://gitlab.com/vala-panel-project/vala-panel-appmenu"
LICENSE="LGPL-3"
SLOT="0"
IUSE="java mate vala-panel xfce wayland +wnck"

RDEPEND=">=x11-libs/gtk+-3.12.0:3[wayland?]
	$(vala_depend)
	>=dev-libs/libdbusmenu-16.04.0
	virtual/pkgconfig
	sys-devel/gettext"
DEPEND="${RDEPEND}
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	>=x11-libs/bamf-0.5.0
	java? ( 
		>=virtual/jdk-1.8.0 
		x11-libs/libxkbcommon
	)
	mate? ( mate-base/mate-panel )
	vala-panel? ( x11-misc/vala-panel )
	xfce? ( >=xfce-base/xfce4-panel-4.11.2 )
	wnck? ( >=x11-libs/libwnck-3.4.0 )"

src_prepare() {
	if use !wayland;then
		sed -i 's/WAYLAND//' CMakeLists.txt
		sed -i 's/WAYLAND//' subprojects/appmenu-gtk-module/CMakeLists.txt
		sed -i 's/\${WAYLAND_INCLUDE}//'  subprojects/appmenu-gtk-module/src/CMakeLists.txt
	fi
	vala_src_prepare
	default
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_JAYATANA="$(usex java ON OFF)"
		-DENABLE_MATE="$(usex mate ON OFF)"
		-DENABLE_VALAPANEL="$(usex vala-panel ON OFF)"
		-DENABLE_XFCE="$(usex xfce ON OFF)"
		-DENABLE_WNCK="$(usex wnck ON OFF)"
		-DGSETTINGS_COMPILE=OFF
	)
	cmake-utils_src_configure
}

src_install () {
	cmake-utils_src_install
	exeinto /etc/X11/xinit/xinitrc.d
    newexe "${FILESDIR}"/appmenu-gtk-module.sh 80-appmenu-gtk-module
	if use java ; then 
		newexe "${FILESDIR}"/appmenu-java-module.sh 80-appmenu-java-module
	fi
	dodoc README.md
}

pkg_postinst() {
	gnome2_schemas_update
}
pkg_postrm() {
	gnome2_schemas_update
}
