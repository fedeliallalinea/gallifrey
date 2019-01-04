# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit user

DESCRIPTION="Sencha Cmd is a command-line tool for develop in ExtJS and Senca Touch"
HOMEPAGE="https://www.sencha.com/products/extjs/cmd-download/"
SRC_URI="x86? ( http://cdn.sencha.com/cmd/${PV}/SenchaCmd-${PV}-linux.run.zip )
	amd64? ( http://cdn.sencha.com/cmd/${PV}/SenchaCmd-${PV}-linux-x64.run.zip )
"

LICENSE="sencha"
SLOT="4.0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="virtual/jre:1.8
	app-eselect/eselect-sencha-cmd"
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}"

pkg_setup() {
	enewgroup sencha
}

src_prepare() {
	default

	chmod +x ${A/\.zip/} || die
	./${A/\.zip/} --mode unattended \
		--prefix "${S}" > /dev/null || die "unpack failed"

	rm "${S}"/"${A/\.zip/}" || die
	rm "${S}"/Sencha/Cmd/${PV}/*ninstall* || die
}

QA_PREBUILT="
	opt/${PN}/${SLOT}/phantomjs/phantomjs
	opt/${PN}/${SLOT}/vcdiff/vcdiff
"

src_install() {
	insinto "/opt/${PN}/${SLOT}"
	doins -r Sencha/Cmd/${PV}/*
	insopts -m755
	doins Sencha/Cmd/${PV}/sencha-${PV}

	exeinto "/opt/${PN}/${SLOT}/phantomjs"
	doexe Sencha/Cmd/${PV}/phantomjs/phantomjs
	exeinto "/opt/${PN}/${SLOT}/vcdiff"
	doexe Sencha/Cmd/${PV}/vcdiff/vcdiff

	cat - > "${D}"/opt/${PN}/${SLOT}/sencha <<EOF || die
#!/bin/sh
/opt/${PN}/${SLOT}/sencha-${PV} $@
EOF
	fperms 0755 /opt/${PN}/${SLOT}/sencha

	dodir "/opt/${PN}/repo"
	fowners root:sencha "/opt/${PN}/repo"
	fperms g+w "/opt/${PN}/repo"
}

pkg_postinst() {
	elog "You must be in the sencha group to manage the development environment."
	elog "Just run 'gpasswd -a <USER> sencha', then have <USER> re-login."
}
