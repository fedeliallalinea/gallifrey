# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/virtualjaguar-libretro"
inherit libretro-core

DESCRIPTION="Libretro for Atari Jaguar Emulator"
HOMEPAGE="https://github.com/libretro/virtualjaguar-libretro"

LICENSE="GPL-2"
SLOT="0"

RDEPEND="${DEPEND}
	games-emulation/libretro-info"
