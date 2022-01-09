# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Sencha Cmd is a command-line tool for develop in ExtJS and Senca Touch"
HOMEPAGE="https://www.sencha.com/products/extjs/cmd-download/"
SRC_URI="x86? ( http://cdn.sencha.com/cmd/${PV}/SenchaCmd-${PV}-linux.run.zip )
	amd64? ( http://cdn.sencha.com/cmd/${PV}/SenchaCmd-${PV}-linux-x64.run.zip )
"

LICENSE="sencha"
SLOT="5.1"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="virtual/jre:1.8
	acct-group/sencha
	app-eselect/eselect-sencha-cmd"
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}"

src_prepare() {
	default

	chmod +x ${A/\.zip/} || die
	./${A/\.zip/} --mode unattended \
		--prefix "${S}" > /dev/null || die "unpack failed"

	rm "${S}"/"${A/\.zip/}" || die
	rm "${S}"/Sencha/Cmd/${PV}/*ninstall* || die
}

QA_PREBUILT="
	opt/${PN}/${SLOT}/bin/linux*/*/*
"

src_install() {
	insinto "/opt/${PN}/${SLOT}"
	doins -r Sencha/Cmd/${PV}/*
	insopts -m755
	doins Sencha/Cmd/${PV}/sencha-${PV}

	local EXT_BIN_DIR
	if use x86 then; then
		EXT_BIN_DIR=linux
	else
		EXT_BIN_DIR=linux-x64
	fi

	exeinto "/opt/${PN}/${SLOT}/bin/${EXT_BIN_DIR}/phantomjs"
	doexe Sencha/Cmd/${PV}/bin/"${EXT_BIN_DIR}"/phantomjs/phantomjs
	exeinto "/opt/${PN}/${SLOT}/bin/${EXT_BIN_DIR}/vcdiff"
	doexe Sencha/Cmd/${PV}/bin/"${EXT_BIN_DIR}"/vcdiff/vcdiff

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
