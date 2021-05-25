# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..9} )
inherit gnome2-utils meson python-single-r1

DESCRIPTION="Share files across the LAN"
HOMEPAGE="https://github.com/linuxmint/warpinator"
SRC_URI="https://github.com/linuxmint/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="ufw"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/cryptography[${PYTHON_USEDEP}]
		dev-python/grpcio[${PYTHON_USEDEP}]
		dev-python/netifaces[${PYTHON_USEDEP}]
		dev-python/packaging[${PYTHON_USEDEP}]
		dev-python/pynacl[${PYTHON_USEDEP}]
		dev-python/setproctitle[${PYTHON_USEDEP}]
		dev-python/xapp[${PYTHON_USEDEP}]
		dev-python/zeroconf[${PYTHON_USEDEP}]
	')
	>=x11-libs/xapps-2.0.6[introspection]
"
DEPEND="
	${RDEPEND}
	$(python_gen_cond_dep '
		dev-python/grpcio-tools[${PYTHON_USEDEP}]
		dev-python/protobuf-python[${PYTHON_USEDEP}]
	')
"

src_prepare() {
	default
	python_fix_shebang install-scripts src
}

src_configure() {
	local emesonargs=(
		$(meson_use ufw include-firewall-mod)
	)
	meson_src_configure
}

src_install() {
	meson_src_install
	python_optimize "${ED}"/usr/libexec/warpinator
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_pkg_postrm
	gnome2_schemas_update
}
