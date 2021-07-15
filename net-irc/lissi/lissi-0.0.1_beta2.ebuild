# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV="${PV/_beta/b1}"

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{8..9} )

inherit distutils-r1

SRC_URI="https://github.com/fedeliallalinea/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="IRC bot expandable via plugins"
HOMEPAGE="https://github.com/fedeliallalinea/lissi"

LICENSE="GPL-2"
SLOT="0"

RDEPEND="
	acct-user/lissi
	dev-python/beautifulsoup[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
"

src_prepare() {
	default
	sed -i "s:file =:file = /var/log/${PN}/${PN}.log:" etc/lissi.cfg || die
}

src_install() {
	distutils-r1_src_install

	touch ${PN}.log
	insinto /var/log/${PN}
	doins ${PN}.log
	fowners ${PN} /var/log/${PN}/
	fowners ${PN} /var/log/${PN}/${PN}.log

	newinitd etc/${PN}.init ${PN}
}

pkg_postinst() {
	elog
	elog "Remeber to configure bot via /etc/lissi.cfg"
	elog
}
