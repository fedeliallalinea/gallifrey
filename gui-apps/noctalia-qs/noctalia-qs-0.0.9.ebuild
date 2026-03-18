# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit branding cmake xdg-utils

GIT_REVISION=b58414209fce1669cff818e50468e926613baa10

DESCRIPTION="Toolkit for building desktop widgets using QtQuick"
HOMEPAGE="https://quickshell.org/"

if [[ "${PV}" = *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/noctalia-dev/noctalia-qs.git"
else
	SRC_URI="https://github.com/noctalia-dev/noctalia-qs/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="LGPL-3"
SLOT="0"

# Upstream recommends leaving all build options enabled by default
IUSE="
	+jemalloc +sockets
	+wayland +layer-shell +session-lock +toplevel-management
	+hyprland +screencopy crash-reporter
	+X +i3
	+tray +pipewire +mpris +pam +polkit +greetd +upower +notifications
	+bluetooth +network
	lto
"
REQUIRED_USE="
	layer-shell?         ( wayland )
	session-lock?        ( wayland )
	toplevel-management? ( wayland )
	hyprland?            ( wayland )
	screencopy?          ( wayland )
"

RDEPEND="
	!gui-apps/quickshell
	dev-qt/qtbase:6=[dbus,vulkan]
	dev-qt/qtsvg:6=
	dev-qt/qtdeclarative:6=
	jemalloc? ( dev-libs/jemalloc )
	wayland? (
		dev-libs/wayland
		dev-qt/qtwayland:6=
	)
	screencopy? (
		x11-libs/libdrm
		media-libs/mesa
	)
	X? ( x11-libs/libxcb )
	pipewire? ( media-video/pipewire )
	pam? ( sys-libs/pam )
	polkit? (
		sys-auth/polkit
		dev-libs/glib
	)
	bluetooth? ( net-wireless/bluez )
	network? ( net-misc/networkmanager )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	dev-cpp/cli11
	dev-util/spirv-tools
	dev-qt/qtshadertools:6
	crash-reporter? ( dev-cpp/cpptrace[libunwind] )
	screencopy? ( dev-util/vulkan-headers )
	wayland? (
		dev-util/wayland-scanner
		dev-libs/wayland-protocols
	)
"

src_configure() {
	# hyprland controls all Hyprland sub-features as a group.
	# i3 controls I3/Sway IPC.
	# screencopy controls all screencopy backends (icc, wlr, hyprland-toplevel).
	local _hyprland=$(usex hyprland)
	local _screencopy=$(usex screencopy)
	local _i3=$(usex i3)

	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=Release
		-DDISTRIBUTOR="${BRANDING_OS_NAME} GURU"
		-DINSTALL_QML_PREFIX="$(get_libdir)/qt6/qml"
		-DCRASH_HANDLER=$(usex crash-reporter)
		-DGIT_REVISION=${GIT_REVISION}
		-DUSE_JEMALLOC=$(usex jemalloc)
		-DSOCKETS=$(usex sockets)
		-DWAYLAND=$(usex wayland)
		-DWAYLAND_WLR_LAYERSHELL=$(usex layer-shell)
		-DWAYLAND_SESSION_LOCK=$(usex session-lock)
		-DWAYLAND_TOPLEVEL_MANAGEMENT=$(usex toplevel-management)
		-DHYPRLAND=${_hyprland}
		-DHYPRLAND_IPC=${_hyprland}
		-DHYPRLAND_GLOBAL_SHORTCUTS=${_hyprland}
		-DHYPRLAND_FOCUS_GRAB=${_hyprland}
		-DHYPRLAND_SURFACE_EXTENSIONS=${_hyprland}
		-DSCREENCOPY=${_screencopy}
		-DSCREENCOPY_ICC=${_screencopy}
		-DSCREENCOPY_WLR=${_screencopy}
		-DSCREENCOPY_HYPRLAND_TOPLEVEL=${_screencopy}
		-DX11=$(usex X)
		-DI3=${_i3}
		-DI3_IPC=${_i3}
		-DSERVICE_STATUS_NOTIFIER=$(usex tray)
		-DSERVICE_PIPEWIRE=$(usex pipewire)
		-DSERVICE_MPRIS=$(usex mpris)
		-DSERVICE_PAM=$(usex pam)
		-DSERVICE_POLKIT=$(usex polkit)
		-DSERVICE_GREETD=$(usex greetd)
		-DSERVICE_UPOWER=$(usex upower)
		-DSERVICE_NOTIFICATIONS=$(usex notifications)
		-DBLUETOOTH=$(usex bluetooth)
		-DNETWORK=$(usex network)
		-DLTO=$(usex lto)
	)
	cmake_src_configure
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}

