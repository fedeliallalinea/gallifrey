# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/prosystem-libretro"
inherit libretro-core

DESCRIPTION="Libretro for Atari 7800 Emulator"
HOMEPAGE="https://github.com/libretro/prosystem-libretro"

LICENSE="GPL-2"
SLOT="0"

RDEPEND="${DEPEND}
	games-emulation/libretro-info"
