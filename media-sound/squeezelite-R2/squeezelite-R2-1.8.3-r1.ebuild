# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit eutils user flag-o-matic git-r3

DESCRIPTION="Small headless Squeezebox emulator. R2 version is designed to play server side decoded and oversampled pcm streams. "
HOMEPAGE="https://github.com/marcoc1712/squeezelite-R2"
SRC_URI="https://github.com/marcoc1712/${PN}/archive/v${PV}-(R2).tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="dsd resample visexport ffmpeg lirc"

DEPEND="media-libs/alsa-lib
		media-libs/flac
		media-libs/libvorbis
		media-libs/libmad
		media-libs/faad2
		media-sound/mpg123
		resample? ( media-libs/soxr )
		visexport? ( media-sound/jivelite )
		ffmpeg? ( media-video/ffmpeg )
		lirc? ( app-misc/lirc )
"
RDEPEND="${DEPEND}
		 media-sound/alsa-utils"

pkg_setup() {
	# Create the user and group if not already present
	enewgroup squeezelite
	enewuser squeezelite -1 -1 "/dev/null" audio
}

src_unpack() {
	mkdir ${S}
	tar -xzvf ${DISTDIR}/${P}.tar.gz -C ${S} --strip-components=1 &> /dev/null || die "unpack failed"	
}

src_prepare () {
	# Apply patches
	epatch "${FILESDIR}/${PN}-gentoo-makefile.patch"
	eapply_user
}

src_compile() {
	if use dsd; then
		append-cflags "-DDSD"
		einfo "dsd support enabled via dsd2pcm"
	fi

	if use ffmpeg; then
		append-cflags "-DFFMPEG"
		einfo "alac and wma support enabled via ffmpeg"
	fi

	if use resample; then
		append-cflags "-DRESAMPLE"
		einfo "resample support enabled via soxr"
	fi

	if use visexport; then
		append-cflags "-DVISEXPORT"
		einfo "audio data export to jivelite support enabled"
	fi
	
	if use lirc; then
		append-cflags "-DIR"
		einfo "infra-red support enabled via lirc"
	fi
	
	# Build it
	emake || die "emake failed"
}

src_install() {
	dobin squeezelite-R2
	dodoc LICENSE.txt

	newconfd "${FILESDIR}/${PN}.conf.d" "${PN}"
	newinitd "${FILESDIR}/${PN}.init.d" "${PN}"
}

pkg_postinst() {
	# Provide some post-installation tips.
	elog "If you want start Squeezelite automatically on system boot:"
	elog "  rc-update add squeezelite-R2 default"
	elog "Edit /etc/conf.d/squeezelite-R2 to customise -- in particular"
	elog "you may want to set the audio device to be used."
}
