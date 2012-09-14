# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="yes"
MATE_LA_PUNT="yes"
PYTHON_DEPEND="2"

inherit mate python

DESCRIPTION="Libraries for the MATE desktop that are not part of the UI"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2 FDL-1.1 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="doc"

# GTK3 doesn't actually work, so hard dep on gtk+-2
RDEPEND="x11-libs/gtk+:2
	>=dev-libs/glib-2.19.1:2
	dev-libs/libunique:1
	>=x11-libs/libXrandr-1.2
	>=mate-base/mate-conf-1.2.1
	>=x11-libs/startup-notification-0.5"

DEPEND="${RDEPEND}
	dev-util/gtk-doc
	>=dev-util/intltool-0.40
	virtual/pkgconfig
	>=app-text/mate-doc-utils-1.2.1
	~app-text/docbook-xml-dtd-4.1.2
	x11-proto/xproto
	>=x11-proto/randrproto-1.2"

PDEPEND=">=dev-python/pygtk-2.8:2
	>=dev-python/pygobject-2.14:2"

# Includes X11/Xatom.h in libgnome-desktop/gnome-bg.c which comes from xproto
# Includes X11/extensions/Xrandr.h that includes randr.h from randrproto (and
# eventually libXrandr shouldn't RDEPEND on randrproto)

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
	G2CONF="${G2CONF}
		PYTHON=$(PYTHON -a)
		--disable-deprecations
		$(use_enable doc desktop-docs)"
	DOCS="AUTHORS ChangeLog HACKING NEWS README"
}

src_prepare() {
	epatch "${FILESDIR}"/0001-Add-lm-since-we-use-sqrt-floor-fmod-and-pow.patch
	mate_src_prepare
}
