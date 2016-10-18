# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils git-r3

DESCRIPTION="Experimental squeezebox and derivative control application"
HOMEPAGE="https://code.google.com/p/jivelite/"

EGIT_REPO_URI="https://code.google.com/p/jivelite/"
EGIT_COMMIT="de07c79a717fa678d8ae8d87f5ef41d16357949b"

LICENSE="jivelite"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-lang/luajit
	dev-lua/lua-cjson
	dev-lua/luacrypto
	dev-lua/luaexpat
	dev-lua/luafilesystem
	dev-lua/luasocket
	media-libs/libsdl
	media-libs/sdl-image[png]
	media-libs/sdl-ttf
	media-libs/sdl-gfx
"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i -e 's;-lpthread;-lpthread -lrt;' "src/Makefile"
	sed -i -e 's;"arp ";"/sbin/arp ";' "share/jive/jive/net/NetworkThread.lua"
	epatch_user
}

src_compile() {
	emake -C src PREFIX=/usr
}

src_install() {
	dobin bin/jivelite
	insinto /usr/share/jive

	doins -r share/jive/jive

	doins -r share/jive/fonts
	doins -r share/jive/applets

	for i in loop ltn12.lua lxp mime.lua socket socket.lua ; do
		doins -r share/lua/5.1/$i
	done
}
