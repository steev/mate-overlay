# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="no"
PYTHON_DEPEND="2:2.5"

inherit mate

DESCRIPTION="Mate indicator applet"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2 FDL-1.1 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE=""

RDEPEND=">=x11-libs/gtk+-2.20:2"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	>=dev-util/intltool-0.35"

