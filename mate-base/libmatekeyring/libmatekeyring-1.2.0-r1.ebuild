# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
WANT_AUTOMAKE="1.9"
GCONF_DEBUG="yes"
MATE_LA_PUNT="yes"

inherit mate

DESCRIPTION="Compatibility library for accessing secrets for MATE"
HOMEPAGE="http://mate-desktop.org"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="debug doc test"

RDEPEND=">=sys-apps/dbus-1.0
	>=mate-base/mate-keyring-1.2.1[test?]"

DEPEND="${RDEPEND}
	sys-devel/gettext
	>=dev-util/intltool-0.35
	virtual/pkgconfig
	doc? ( >=dev-util/gtk-doc-1.9 )"

pkg_setup() {
	G2CONF="${G2CONF}
		$(use_enable debug)
		$(use_enable test tests)"
	DOCS="AUTHORS ChangeLog NEWS README"
}

src_prepare() {
	# Remove silly CFLAGS
	sed 's:CFLAGS="$CFLAGS -Werror:CFLAGS="$CFLAGS:' \
		-i configure.in configure || die "sed failed"

	# Remove DISABLE_DEPRECATED flags
	sed -e '/-D[A-Z_]*DISABLE_DEPRECATED/d' \
		-i configure.in configure || die "sed 2 failed"

	mate_src_prepare
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS
	emake check
}
