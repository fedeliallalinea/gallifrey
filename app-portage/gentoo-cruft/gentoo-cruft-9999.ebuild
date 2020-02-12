# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CRATES=""

inherit cargo git-r3

DESCRIPTION=" Find files not recorded in the Gentoo package database"
HOMEPAGE="https://crates.io/crates/gentoo-cruft https://github.com/xelkarin/gentoo-cruft"
#SRC_URI="$(cargo_crate_uris ${CRATES})"
EGIT_REPO_URI="https://github.com/xelkarin/${PN}"

LICENSE="MIT
	|| ( Apache-2.0 MIT )
	|| ( Apache-2.0 Boost-1.0 )
	|| ( Unlicense MIT )"
SLOT="0"
IUSE=""

BDEPEND=">=virtual/rust-1.37.0"

DOCS=( LICENSE README.md config/cruft.yaml )

src_unpack() {
	git-r3_src_unpack
	cargo_live_src_unpack
}

src_install() {
	cargo_src_install
	einstalldocs
}

pkg_postinst() {
	elog ""
	elog "The configuration files /etc/cruft.yaml and \$HOME/.config/cruft.yaml"
	elog " will be read if they are available. An example is provided at"
	elog "/usr/share/doc/${P}/cruft.yaml.bz2"
	elog ""
}
