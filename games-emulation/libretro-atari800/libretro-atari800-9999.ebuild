# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/${PN}"
inherit libretro-core

DESCRIPTION="Libretro for Atari 5200 Emulator"
HOMEPAGE="https://github.com/libretro/libretro-atari800"

LICENSE="GPL-2"
SLOT="0"

RDEPEND="${DEPEND}
	games-emulation/libretro-info"
