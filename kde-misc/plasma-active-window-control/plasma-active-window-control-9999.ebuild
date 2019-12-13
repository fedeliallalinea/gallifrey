# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 kde5

DESCRIPTION="Plasma 5 applet for controlling currently active window"
HOMEPAGE="https://store.kde.org/p/998910/
https://github.com/KDE/plasma-active-window-control"
EGIT_REPO_URI="https://github.com/KDE/${PN}"

LICENSE="GPL-2+"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
        $(add_frameworks_dep plasma)
"
RDEPEND="${DEPEND}"
