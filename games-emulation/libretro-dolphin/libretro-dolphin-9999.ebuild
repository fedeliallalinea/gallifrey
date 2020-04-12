# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils git-r3

DESCRIPTION="Libretro for GameCube/Wii Emulator"
HOMEPAGE="https://github.com/libretro/dolphin"
EGIT_REPO_URI="https://github.com/libretro/dolphin"

LICENSE="GPL-2"
SLOT="0"
IUSE="bluetooth egl"

RDEPEND="
	dev-libs/lzo
	games-emulation/libretro-info
	media-libs/libpng:0=
	media-libs/libsfml
	net-libs/enet:1.3
	net-libs/mbedtls
	sys-libs/readline:0=
	sys-libs/zlib:=
	x11-libs/libXext
	x11-libs/libXi
	x11-libs/libXrandr
	virtual/libusb:1
	virtual/opengl
	bluetooth? ( net-wireless/bluez )
	egl? ( media-libs/mesa[egl] )
"

src_configure() {
	local mycmakeargs=(
		-DLIBRETRO=ON
		-DLIBRETRO_STATIC=1
		-DBUILD_SHARED_LIBS=OFF
		-DUSE_SHARED_ENET=ON
		-DENABLE_ANALYTICS=OFF
		-DENABLE_EGL=$(usex egl)
	)
	cmake-utils_src_configure
}

src_install() {
	exeinto /usr/$(get_libdir)/libretro
	doexe "${BUILD_DIR}"/dolphin_libretro.so
}

pkg_postinst() {
	elog ""
	elog "For a correct operation in retroarch you should following setup instructions:"
	elog ""
	elog "https://docs.libretro.com/library/dolphin/#setup"
	elog ""
}
