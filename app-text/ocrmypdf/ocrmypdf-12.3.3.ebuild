# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{7..9} )

inherit bash-completion-r1 distutils-r1

SRC_URI="https://github.com/jbarlow83/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64"

DESCRIPTION="OCRmyPDF adds an OCR text layer to scanned PDF files"
HOMEPAGE="https://ocrmypdf.readthedocs.io/en/latest/"

LICENSE="GPL-3 test? ( CC-BY-SA-2.5 CC-BY-SA-3.0 CC-BY-SA-4.0 public-domain )"
SLOT="0"
IUSE="doc"
IUSE="doc jbig test"
RESTRICT="!test? ( test )"

DEPEND="
	>=dev-python/cffi-1.14.3[${PYTHON_USEDEP}]
	test? (
		>=dev-python/pytest-5.0.0[${PYTHON_USEDEP}]
		dev-python/pytest-helpers-namespace[${PYTHON_USEDEP}]
		>=dev-python/pytest-xdist-1.31[${PYTHON_USEDEP}]
		>=dev-python/pytest-cov-2.10.1[${PYTHON_USEDEP}]
		dev-python/python-xmp-toolkit[${PYTHON_USEDEP}]
	)
"

# with opencl enabled on tesserct there is a problem with language
# and also tesseract has a problem 
# https://github.com/tesseract-ocr/tesseract/issues/837
RDEPEND="
	app-text/ghostscript-gpl
	>=app-text/pdfminer_six-20201018[${PYTHON_USEDEP}]
	>=app-text/tesseract-4.0.0[-opencl]
	app-text/unpaper
	dev-python/chardet[${PYTHON_USEDEP}]
	>=dev-python/coloredlogs-14.0[${PYTHON_USEDEP}]
	>=dev-python/pikepdf-2.10.0[${PYTHON_USEDEP}]
	>=dev-python/pillow-8.0.1[${PYTHON_USEDEP}]
	>=dev-python/pluggy-0.13.1[${PYTHON_USEDEP}]
	>=dev-python/reportlab-3.5.55[${PYTHON_USEDEP}]
	dev-python/sortedcontainers[${PYTHON_USEDEP}]
	>=dev-python/tqdm-4.51.0[${PYTHON_USEDEP}]
	>=media-gfx/img2pdf-0.4.0[${PYTHON_USEDEP}]
	media-gfx/pngquant
	media-libs/leptonica
	jbig? ( media-libs/jbig2enc )
"

S="${WORKDIR}/OCRmyPDF-${PV}"

distutils_enable_tests pytest
distutils_enable_sphinx docs --no-autodoc

src_install() {
	distutils-r1_src_install

	dobashcomp misc/completion/ocrmypdf.bash
	insinto /usr/share/fish/vendor_completions.d
	doins misc/completion/ocrmypdf.fish
}
