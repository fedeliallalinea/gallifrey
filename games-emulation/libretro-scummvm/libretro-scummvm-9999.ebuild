# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/scummvm"
inherit libretro-core

DESCRIPTION="libretro implementation of ScummVM"
HOMEPAGE="https://github.com/libretro/scummvm"
KEYWORDS=""

LICENSE="GPL-2 BSD GPL-3 LGPL-2.1"
SLOT="0"

DEPEND=""
RDEPEND="${DEPEND}
	games-emulation/libretro-info"

S="${S}/backends/platform/libretro/build"
