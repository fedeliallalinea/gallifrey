# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

if [[ ${PV} == "99999999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="git://github.com/fedeliallalinea/${PN}.git"
else
	SRC_URI="https://github.com/fedeliallalinea/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Eselect module for manages multiple Android Build tools versions"
HOMEPAGE="https://github.com/fedeliallalinea/eselect-android-build-tools"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND=">=app-admin/eselect-1.2.3"

src_install() {
	insinto /usr/share/eselect/modules
	doins android-build-tools.eselect
}
