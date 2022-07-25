# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

SRC_URI="https://github.com/fedeliallalinea/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="IRC bot expandable via plugins"
HOMEPAGE="https://github.com/fedeliallalinea/lissi"

LICENSE="GPL-2"
SLOT="0"
IUSE="+fortune"

RDEPEND="
	acct-user/lissi
	dev-python/beautifulsoup4[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	fortune? ( games-misc/fortune-mod )
"

src_prepare() {
	default
	sed -i "s:file =:file = /var/log/${PN}/${PN}.log:" etc/lissi.cfg || die
	if ! use fortune; then
		sed -i "s:,fortune::" etc/lissi.cfg || die
	fi
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
