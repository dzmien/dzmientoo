# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 meson xdg-utils gnome2-utils

EGIT_REPO_URI="https://git.sr.ht/~alextee/zrythm"

DESCRIPTION="Zrythm is a digital audio workstation designed to be featureful and easy to use."
HOMEPAGE="https://www.zrythm.org/"
LICENSE="GPL-3"
SLOT="0"

DEPEND="
	app-arch/zstd
	dev-libs/libbacktrace
	>dev-libs/libcyaml-1.1.0
	dev-libs/libpcre
	>=dev-libs/reproc-14.1.0
	dev-scheme/guile
	kde-frameworks/breeze-icons
	media-libs/lilv
	>=media-libs/libaudec-0.2.3
	media-libs/chromaprint
	media-libs/rubberband
	sci-libs/fftw:*[threads]
	x11-libs/gtk+:3
	x11-libs/gtksourceview:*
"
RDEPEND="${DEPEND}"
BDEPEND="
	>=dev-util/meson-0.57.0
"

src_prepare() {
	default
	# Don't force subproject. The ebuild requires a future release, we're fine.
	sed -i "s/'libcyaml', required: false, version: '>=99.1.0'/'libcyaml', required: false/g" "${S}/meson.build"
}

src_install() {
	DESTDIR="${D}" eninja -C "${BUILD_DIR}" install
}

pkg_postinst() {
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
	xdg_icon_cache_update
	gnome2_schemas_update
}

pkg_postrm() {
	xdg_mimeinfo_database_update
	xdg_desktop_database_update
	xdg_icon_cache_update
	gnome2_schemas_update
}
