# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/FBNeo"
inherit libretro-core

DESCRIPTION="Libretro core for Final Burn Alpha fork"
HOMEPAGE="https://github.com/libretro/FBNeo"

LICENSE="FBA"
SLOT="0"

RDEPEND="${DEPEND}
	games-emulation/libretro-info"

S="${S}/src/burner/libretro"

src_compile() {
	local MY_OPTS=""
	if use amd64 || use x86 ; then
		MY_OPTS="USE_X64_DRC=1"
	elif use arm64 || use arm ; then
		MY_OPTS="USE_CYCLONE=1"
	fi

	myemakeargs="${MY_OPTS}" \
		libretro-core_src_compile
}
