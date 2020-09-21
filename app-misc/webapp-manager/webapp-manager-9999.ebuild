# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )

inherit git-r3 gnome2-utils python-r1 xdg

DESCRIPTION="Run websites as if they were apps"
HOMEPAGE="https://github.com/linuxmint/webapp-manager"
EGIT_REPO_URI="https://github.com/linuxmint/webapp-manager"

LICENSE="GPL-3"
SLOT="0"
IUSE="chromium epiphany firefox vivaldi"
REQUIRED_USE="${PYTHON_REQUIRED_USE} || ( chromium epiphany firefox vivaldi )"

DEPEND="${PYTHON_DEPS}
	dev-python/beautifulsoup[${PYTHON_USEDEP}]
	dev-python/configobj[${PYTHON_USEDEP}]
	dev-python/pygobject[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/setproctitle[${PYTHON_USEDEP}]
	dev-python/tldextract[${PYTHON_USEDEP}]
	gnome-base/dconf
	x11-libs/xapps
	chromium? ( || (
		www-client/chromium
		www-client/google-chrome
	) )
	epiphany? ( www-client/epiphany )
	firefox? ( || (
		www-client/firefox
		www-client/firefox-bin
	) )
	vivaldi? ( www-client/vivaldi )"
RDEPEND="${DEPEND}"
BDEPEND=""

src_install() {
	python_foreach_impl python_install

	insinto /usr/share
	doins -r usr/share/{applications,desktop-directories,glib-2.0,icons,locale,webapp-manager}

	insinto /etc
	doins -r etc/.
}

python_install() {
	python_domodule "${S}/usr/lib/webapp-manager/common.py"
	python_domodule "${S}/usr/lib/webapp-manager/webapp-manager.py"

	python_newscript "${S}/usr/lib/webapp-manager/webapp-manager.py" webapp-manager
	python_optimize
}

pkg_preinst() {
	xdg_pkg_preinst
	gnome2_schemas_savelist
}

pkg_postinst() {
	xdg_pkg_postinst
	gnome2_schemas_update
}
