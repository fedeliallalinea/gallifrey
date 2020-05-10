# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit git-r3

DESCRIPTION="A full-screen Expose-style standalone task switcher for X11"
HOMEPAGE="https://github.com/richardgv/skippy-xd"
EGIT_REPO_URI="https://github.com/richardgv/skippy-xd"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND="media-libs/imlib2[X]
	x11-libs/libXext
	x11-libs/libX11
	x11-libs/libXinerama
	x11-libs/libXmu
	x11-libs/libXft"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
	virtual/pkgconfig"

DOCS=( CHANGELOG skippy-xd.sample.rc )
