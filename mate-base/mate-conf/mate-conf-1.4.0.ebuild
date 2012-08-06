# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
WANT_AUTOMAKE="1.9"
GCONF_DEBUG="yes"
MATE_LA_PUNT="yes"

inherit mate

DESCRIPTION="A configuration database system for MATE"
HOMEPAGE="http://mate-desktop.org"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="debug doc gtk3 +introspection ldap policykit"

RDEPEND=">=dev-libs/glib-2.25.9:2
	gtk3? ( x11-lib/gtk+:3 )
	!gtk3? ( x11-libs/gtk+:2 )
	>=dev-libs/dbus-glib-0.74
	>=sys-apps/dbus-1
	>=mate-base/mate-common-1.2.2
	>=mate-base/mate-corba-1.2.2
	>=dev-libs/libxml2-2:2
	introspection? ( >=dev-libs/gobject-introspection-0.9.5 )
	ldap? ( net-nds/openldap )
	policykit? ( sys-auth/polkit )"
DEPEND="${RDEPEND}
	>=dev-util/intltool-0.35
	virtual/pkgconfig
	doc? ( >=dev-util/gtk-doc-1 )"

pkg_setup() {
	DOCS="AUTHORS ChangeLog NEWS README TODO"
	G2CONF="${G2CONF}
		--enable-gtk
		--disable-static
		--enable-gsettings-backend
		$(use_enable introspection)
		$(use_with ldap openldap)
		$(use_enable policykit defaults-service)"
	kill_mateconf

	# Need host's IDL compiler for cross or native build, bug #262747
	export EXTRA_EMAKE="${EXTRA_EMAKE} MATECORBA_IDL=/usr/bin/matecorba-idl-2"
}

src_install() {
	mate_src_install

	keepdir /etc/mateconf/mateconf.xml.mandatory
	keepdir /etc/mateconf/mateconf.xml.defaults
	# Make sure this directory exists, bug #268070, upstream #572027
	keepdir /etc/mateconf/mateconf.xml.system

	echo 'CONFIG_PROTECT_MASK="/etc/mateconf"' > 50mateconf
	echo 'GSETTINGS_BACKEND="mateconf"' >> 50mateconf
	doenvd 50mateconf || die "doenv failed"
	dodir /root/.mateconfd || die
}

pkg_preinst() {
	kill_mateconf
}

pkg_postinst() {
	kill_mateconf

	# change the permissions to avoid some gconf bugs
	einfo "changing permissions for mateconf dirs"
	find  /etc/mateconf/ -type d -exec chmod ugo+rx "{}" \;

	einfo "changing permissions for mateconf files"
	find  /etc/mateconf/ -type f -exec chmod ugo+r "{}" \;
}

kill_mateconf() {
	# This function will kill all running mateconfd-2 that could be causing troubles
	if [ -x /usr/bin/mateconftool-2 ]; then
		/usr/bin/mateconftool-2 --shutdown
	fi

	return 0
}
