# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..9} )
DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1

DESCRIPTION="python-gphoto2 is a comprehensive Python binding to libgphoto2"
HOMEPAGE="https://pypi.org/project/gphoto2 https://github.com/jim-easterbrook/python-gphoto2"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz -> python-${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	media-libs/libgphoto2
"
DEPEND="${RDEPEND}"
