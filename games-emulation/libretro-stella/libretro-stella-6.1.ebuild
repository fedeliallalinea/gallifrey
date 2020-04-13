# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="stella-emu/stella"
if [[ ${PV} != "9999" ]] ; then
	LIBRETRO_COMMIT_SHA="a3b536c94d93d72887d84cd1bbc0327c42db2535"
	KEYWORDS="~amd64"
fi

inherit libretro-core

DESCRIPTION="Libretro for Atari 2600 Emulator"
HOMEPAGE="https://github.com/stella-emu/stella"

LICENSE="GPL-2"
SLOT="0"

RDEPEND="${DEPEND}
	games-emulation/libretro-info"

S="${S}/src/libretro"
