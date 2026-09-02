# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A cross-platform R console written in Rust"
HOMEPAGE="https://github.com/eitsupi/arf"
SRC_URI="https://github.com/eitsupi/arf/releases/download/v${PV}/arf-console-x86_64-unknown-linux-gnu.tar.xz -> ${P}.tar.xz"

S="${WORKDIR}/arf-console-x86_64-unknown-linux-gnu"

LICENSE="MIT"
SLOT="0"
KEYWORDS="-* ~amd64"

QA_PREBUILT="usr/bin/arf"

src_install() {
	dobin arf
}
