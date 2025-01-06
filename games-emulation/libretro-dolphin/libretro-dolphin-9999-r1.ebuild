# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake git-r3

DESCRIPTION="Libretro for GameCube/Wii Emulator"
HOMEPAGE="https://github.com/libretro/dolphin"
EGIT_REPO_URI="https://github.com/libretro/dolphin"

LICENSE="GPL-2"
SLOT="0"
IUSE="bluetooth +egl vulkan +X"

DEPEND="
	dev-libs/hidapi:0=
	dev-libs/libfmt:0=
	dev-libs/lzo:2=
	dev-libs/pugixml:0=
	dev-qt/qtconcurrent
	media-libs/libpng:0=
	media-libs/libsfml
	media-libs/mesa
	net-libs/enet:1.3
	net-libs/mbedtls:0=
	net-misc/curl:0=
	sys-libs/readline:0=
	sys-libs/zlib:0=
	X? (
		x11-libs/libXext
		x11-libs/libXi
		x11-libs/libXrandr
	)
	virtual/libusb:1
	bluetooth? ( net-wireless/bluez )
	egl? ( virtual/opengl )
	vulkan? ( media-libs/vulkan-loader )
"
RDEPEND="${DEPEND}
	games-emulation/libretro-info"

PATCHES=(
	"${FILESDIR}/${PN}_fix-reverse-not-member-std.patch"
	"${FILESDIR}/${PN}_fmt-10.patch"
)

src_configure() {
	local mycmakeargs=(
		-DENABLE_LLVM=OFF
		-DBUILD_SHARED_LIBS=OFF
		-DLIBRETRO=ON
		-DLIBRETRO_STATIC=1
		-DENABLE_QT=0
		-DUSE_SHARED_ENET=ON
		-DCMAKE_BUILD_TYPE=Release
		-DCMAKE_INSTALL_PREFIX=/usr
		-DENABLE_X11=$(usex X)
		-DENABLE_EGL=$(usex egl)
	)
	cmake_src_configure
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
