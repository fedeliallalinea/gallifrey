# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# https://bbs.archlinux.org/viewtopic.php?pid=2167442
DESCRIPTION="Automatic generate WM menu from xdg files"
HOMEPAGE="https://wiki.archlinux.org/title/Xdg-menu"
SRC_URI="https://arch.p5n.pp.ru/~sergej/dl/2023/${P}.tar.gz"
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-perl/XML-Parser
"

src_install() {
	dobin xdg_menu{,_su}
	dobin update-menus

	insinto /etc
	doins update-menus.conf

	insinto /usr/share/desktop-directories
	doins arch-desktop-directories/*

	insinto /etc/xdg/menus/
	doins arch-xdg-menu/*
}
