# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{7,8} )

if [[ ${PV} == "9999" ]] ; then
	inherit bash-completion-r1 distutils-r1 git-r3
	EGIT_REPO_URI="https://github.com/jbarlow83/${PN}.git"
else
	inherit bash-completion-r1 distutils-r1
	SRC_URI="https://github.com/jbarlow83/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

DESCRIPTION="OCRmyPDF adds an OCR text layer to scanned PDF files"
HOMEPAGE="https://ocrmypdf.readthedocs.io/en/latest/"

LICENSE="GPL-3 test? ( CC-BY-SA-2.5 CC-BY-SA-3.0 CC-BY-SA-4.0 public-domain )"
SLOT="0"
IUSE="doc"
IUSE="doc jbig test"
RESTRICT="!test? ( test )"

DEPEND="
	dev-python/setuptools_scm[${PYTHON_USEDEP}]
	dev-python/setuptools_scm_git_archive[${PYTHON_USEDEP}]
	>=dev-python/cffi-1.14.3[${PYTHON_USEDEP}]
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinx_rtd_theme[${PYTHON_USEDEP}]
	)
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
	>=dev-python/pikepdf-2.0.0[${PYTHON_USEDEP}]
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

python_prepare_all() {
	# falsely assumes it needs pytest-runner unconditionally and will
	sed -i "s|'pytest-runner',||" setup.py || die

	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && dodir _build/html && sphinx-build -b html docs _build/html
}

python_test() {
	py.test -v tests || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( _build/html/. )
	distutils-r1_python_install_all

	dobashcomp misc/completion/ocrmypdf.bash
	insinto /usr/share/fish/vendor_completions.d
	doins misc/completion/ocrmypdf.fish
}
