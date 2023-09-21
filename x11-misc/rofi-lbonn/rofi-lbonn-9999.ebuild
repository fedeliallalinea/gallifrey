# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg-utils

DESCRIPTION="A fork of Rofi with added support for Wayland"
HOMEPAGE="https://github.com/lbonn/rofi"

if [[ "${PV}" == "9999" ]]; then
	EGIT_REPO_URI="https://github.com/lbonn/rofi"
	inherit git-r3
else
	MY_PV="${PV}+wayland2"
	MY_P="${PN/-lbonn/}-${MY_PV}"
	SRC_URI="https://github.com/lbonn/rofi/releases/download/${MY_PV/+/%2B}/${MY_P}.tar.xz"
	S="${WORKDIR}/${MY_P}"
	KEYWORDS="~amd64"
fi

LICENSE="MIT"
SLOT="0"
IUSE="+drun test wayland +windowmode +X"
REQUIRED_USE="|| ( wayland X )"
RESTRICT="!test? ( test )"

BDEPEND="

	sys-devel/bison
	>=sys-devel/flex-2.5.39
	virtual/pkgconfig
"
RDEPEND="
	dev-libs/glib:2
	!x11-misc/rofi
	wayland? ( dev-libs/wayland-protocols )
	X? (
		x11-libs/cairo[X,xcb(+)]
		x11-libs/gdk-pixbuf:2
		x11-libs/libxcb:=
		x11-libs/libxkbcommon[X]
		x11-libs/pango[X]
		x11-libs/startup-notification
		x11-libs/xcb-util
		x11-libs/xcb-util-cursor
		x11-libs/xcb-util-wm
		x11-misc/xkeyboard-config
	)
"
DEPEND="
	${RDEPEND}
	test? ( >=dev-libs/check-0.11 )
	X? ( x11-base/xorg-proto )
"

src_configure() {
	local emesonargs=(
		$(meson_use drun)
		$(meson_use windowmode window)
		$(meson_feature test check)
		$(meson_feature wayland)
		$(meson_feature X xcb)
	)

	meson_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
