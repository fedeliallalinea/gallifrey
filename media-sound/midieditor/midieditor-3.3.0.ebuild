# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop qmake-utils

DESCRIPTION="MidiEditor is a free software to edit, record, and play Midi data."
HOMEPAGE="https://midieditor.org"
SRC_URI="https://github.com/markusschwenk/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="dev-qt/qtcore:5
	dev-qt/qtmultimedia:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtxml:5
	media-libs/alsa-lib"
RDEPEND="${DEPEND}"

src_configure() {
	eqmake5
}

src_install() {
	dobin MidiEditor
	insinto /usr/share/${PN}
	doins packaging/windows/windows-installer/midieditor.png
	make_desktop_entry "/usr/bin/MidiEditor" "MidiEditor" "/usr/share/${PN}/${PN}.png" "AudioVideo;Audio;"
}
