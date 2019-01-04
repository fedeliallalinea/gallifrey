# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Stream content to Android devices over the Internet"
HOMEPAGE="https://bubblesoftapps.com/bubbleupnpserver/"
SRC_URI="https://bubblesoftapps.com/bubbleupnpserver/BubbleUPnPServer-distrib.zip -> ${P}.zip"

LICENSE="BubbleUPnP-Server"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="virtual/jre:1.8
	media-video/ffmpeg
	dev-libs/nss"
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}"

src_install() {
	insinto "/opt/${PN}/"
	doins BubbleUPnPServerLauncher.jar
	doins bcprov-jdk16-146.jar
	insopts -m755
	doins launch.sh

	newinitd "${FILESDIR}/${PN}.init.d" "${PN}"
}
