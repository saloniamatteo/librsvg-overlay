# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GNOME2_EAUTORECONF="yes"
VALA_USE_DEPEND="vapigen"

inherit autotools gnome2 multilib-minimal vala

DESCRIPTION="Scalable Vector Graphics (SVG) rendering library - with no rust & gtk-doc dependencies"
HOMEPAGE="https://github.com/saloniamatteo/librsvg-overlay https://github.com/oaken-source/librsvg-og"
COMMIT="586e75f88d2deebfcfaa3f61338ffece26d3f521"
SRC_URI="https://github.com/oaken-source/librsvg-og/archive/${COMMIT}.tar.gz -> librsvg.tar.gz"

LICENSE="LGPL-2+"
SLOT="2"
KEYWORDS="~alpha amd64 arm hppa ~ia64 ~mips ppc ~s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos ~sparc-solaris ~x64-solaris ~x86-solaris"

IUSE="introspection vala"
REQUIRED_USE="vala? ( introspection )"

RDEPEND="
	>=dev-libs/glib-2.34.3:2[${MULTILIB_USEDEP}]
	>=dev-libs/libcroco-0.6.8-r1[${MULTILIB_USEDEP}]
	>=dev-libs/libxml2-2.9.1-r4:2[${MULTILIB_USEDEP}]
	>=x11-libs/cairo-1.12.14-r4[${MULTILIB_USEDEP}]
	>=x11-libs/gdk-pixbuf-2.30.7:2[introspection?,${MULTILIB_USEDEP}]
	>=x11-libs/gtk+-3.10.0:3
	>=x11-libs/pango-1.38.0[${MULTILIB_USEDEP}]
	introspection? ( >=dev-libs/gobject-introspection-0.10.8:= )
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-libs/gobject-introspection-common
	dev-libs/vala-common
	dev-util/glib-utils
	virtual/pkgconfig
	x11-libs/gdk-pixbuf
	vala? ( $(vala_depend) )
"
# >=gtk-doc-am-1.13, gobject-introspection-common, vala-common needed by eautoreconf

QA_FLAGS_IGNORED="
	usr/bin/rsvg-convert
	usr/lib.*/librsvg.*
"

RESTRICT="test" # Lots of issues due to freetype changes and more; ever since newer tests got backported into 2.40.19

PATCHES=( "${FILESDIR}/remove-gtk-doc.patch")

src_unpack() {
	unpack "${PN}.tar.gz"
	mv "librsvg-og-${COMMIT}" "${P}"
}

src_prepare() {
	use vala && vala_src_prepare
	gnome2_src_prepare
}

multilib_src_configure() {
	local myconf=(
		--disable-static
		--disable-tools				# enabling this flag seems to have no effect...
		$(multilib_native_use_enable introspection)
		$(multilib_native_use_enable vala)
		--enable-pixbuf-loader
	)

	# -Bsymbolic is not supported by the Darwin toolchain
	[[ ${CHOST} == *-darwin* ]] && myconf+=( --disable-Bsymbolic )

	ECONF_SOURCE=${S} gnome2_src_configure "${myconf[@]}"
}

multilib_src_compile() {
	# causes segfault if set, see bug #411765
	unset __GL_NO_DSO_FINALIZER
	gnome2_src_compile
}

multilib_src_install() {
	gnome2_src_install
}

pkg_postinst() {
	# causes segfault if set, see bug 375615
	unset __GL_NO_DSO_FINALIZER
	multilib_foreach_abi gnome2_pkg_postinst
}

pkg_postrm() {
	# causes segfault if set, see bug 375615
	unset __GL_NO_DSO_FINALIZER
	multilib_foreach_abi gnome2_pkg_postrm
}
