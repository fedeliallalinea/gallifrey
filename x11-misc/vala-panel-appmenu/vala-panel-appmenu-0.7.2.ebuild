# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} == "9999" ]] ; then
	inherit cmake-utils git-r3 gnome2-utils vala
	EGIT_REPO_URI="https://gitlab.com/vala-panel-project/${PN}.git"
else
	inherit cmake-utils gnome2-utils vala
	KEYWORDS="~amd64 ~x86"
	SRC_URI="
		https://gitlab.com/vala-panel-project/${PN}/-/archive/${PV}/${P}.tar.gz
		https://gitlab.com/vala-panel-project/cmake-vala/-/archive/master/cmake-vala-master.tar.gz"
fi

VALA_MIN_API_VERSION="0.34"

DESCRIPTION="Global Menu plugin"
HOMEPAGE="https://gitlab.com/vala-panel-project/vala-panel-appmenu"
LICENSE="LGPL-3"
SLOT="0"
IUSE="budgie java mate vala-panel xfce wnck"

RDEPEND="
	x11-libs/cairo
	>=x11-libs/bamf-0.5.0
	x11-libs/gdk-pixbuf
	>=x11-libs/gtk+-3.12.0:3
	>=x11-libs/gtk+-2.24.0:2
	x11-libs/libwnck:3 
	java? ( 
		>=virtual/jdk-1.8.0 
		x11-libs/libxkbcommon
	)
	mate? ( mate-base/mate-panel )
	vala-panel? ( x11-misc/vala-panel )
	xfce? ( >=xfce-base/xfce4-panel-4.11.2 )
	budgie? ( gnome-extra/budgie-desktop )"
BDEPEND="
	$(vala_depend)
	${RDEPEND}"

PATCHES=(
	"${FILESDIR}/remove-disconnect_by_data-definition.patch"
	"${FILESDIR}/remove-fallback-check.patch"
	"${FILESDIR}/support-new-vala-versions.patch"
)

DOCS=(
	"README.md"
	"LICENSE"
)

src_prepare() {
	if [[ ${PV} != "9999" ]] ; then
		cp -r "${WORKDIR}"/cmake-vala-master/* cmake/ || die "failed to copy cmake-vala"
	fi
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_JAYATANA="$(usex java ON OFF)"
		-DENABLE_MATE="$(usex mate ON OFF)"
		-DENABLE_VALAPANEL="$(usex vala-panel ON OFF)"
		-DENABLE_XFCE="$(usex xfce ON OFF)"
		-DENABLE_BUDGIE="$(usex budgie ON OFF)"
		-DENABLE_APPMENU_GTK_MODULE=ON
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
}

pkg_postinst() {
	gnome2_schemas_update
}
pkg_postrm() {
	gnome2_schemas_update
}
