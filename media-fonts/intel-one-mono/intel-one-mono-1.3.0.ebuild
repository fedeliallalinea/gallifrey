# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit font

DESCRIPTION="Monospaced font family that's built with the needs of developers in mind"
HOMEPAGE="https://github.com/intel/intel-one-mono"
SRC_URI="https://github.com/intel/intel-one-mono/releases/download/V${PV}/ttf.zip -> ${P}-ttf.zip"
S="${WORKDIR}"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

BDEPEND="app-arch/unzip"

S="${WORKDIR}/ttf"
FONT_SUFFIX="ttf"
