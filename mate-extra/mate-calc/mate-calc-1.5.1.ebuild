# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="no"

inherit mate

DESCRIPTION="The MATE System Monitor"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="gtk3"

RDEPEND="gtk3? ( dev-libs/gtk+:3 )
	!gtk3? ( dev-libs/gtk+:2 )
	>=dev-libs/glib-2.20:2
	dev-libs/libxml2:2"

DEPEND="${RDEPEND}
	>=app-text/mate-doc-utils-1.2.1
	virtual/pkgconfig
	>=app-text/scrollkeeper-0.3.11
	>=dev-util/intltool-0.35
	dev-util/gtk-doc"

DOCS="AUTHORS ChangeLog NEWS README"
