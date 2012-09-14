# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
GCONF_DEBUG="no"
MATE_LA_PUNT="yes"
PYTHON_DEPEND="2:2.5"

inherit mate python

DESCRIPTION="The MATE panel"
HOMEPAGE="http://mate-desktop.org"

LICENSE="GPL-2 FDL-1.1 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="doc eds +introspection networkmanager"

RDEPEND=">=mate-base/mate-desktop-1.2.0
	>=x11-libs/pango-1.15.4[introspection?]
	>=dev-libs/glib-2.25.12:2
	x11-libs/gtk+:2[introspection?]
	>=dev-libs/libmateweather-1.2.0
	dev-libs/libxml2:2
	>=mate-base/mate-conf-1.2.1[introspection?]
	>=media-libs/libcanberra-0.23[gtk]
	>=mate-base/mate-menus-1.2.0
	gnome-base/librsvg:2
	>=dev-libs/dbus-glib-0.80
	>=sys-apps/dbus-1.1.2
	>=x11-libs/cairo-1
	x11-libs/libXau
	>=x11-libs/libXrandr-1.2
	>=mate-base/libmatecomponent-1.2.1
	>=mate-base/libmatecomponentui-1.2.0
	>=mate-base/mate-corba-1.2.2
	>=x11-libs/libmatewnck-1.4.0
	eds? ( <gnome-extra/evolution-data-server-3 )
	introspection? ( >=dev-libs/gobject-introspection-0.6.7 )
	networkmanager? ( >=net-misc/networkmanager-0.6.7 )"
DEPEND="${RDEPEND}
	>=dev-lang/perl-5
	>=app-text/mate-doc-utils-1.2.1
	virtual/pkgconfig
	>=dev-util/intltool-0.40
	~app-text/docbook-xml-dtd-4.1.2
	doc? ( >=dev-util/gtk-doc-1 )
	>=mate-base/mate-common-1.2.2
	dev-util/gtk-doc-am"

src_compile() {
	epatch ${FILESDIR}/clock-applet-include-fix.patch
	mate_src_compile
}

pkg_setup() {
	# possible values: none, clock, fish, notification-area, wncklet, all
	local applets="all"
	G2CONF="${G2CONF}
		--libexecdir=/usr/libexec/mate-applets
		--disable-deprecation-flags
		--with-in-process-applets=${applets}
		--enable-matecomponent
		$(use_enable networkmanager network-manager)
		$(use_enable introspection)
		$(use_enable eds)"
	DOCS="AUTHORS ChangeLog HACKING NEWS README"
	python_set_active_version 2
}

pkg_postinst() {
	local entries="${EROOT}etc/mateconf/schemas/panel-default-setup.entries"
	local mateconftool="${EROOT}usr/bin/mateconftool-2"

	if [[ -e "${entries}" ]]; then
		einfo "Setting panel mateconf defaults..."

		MATECONF_CONFIG_SOURCE="$("${mateconftool}" --get-default-source | sed "s;:/;:${ROOT};")"
		"${mateconftool}" --direct --config-source "${MATECONF_CONFIG_SOURCE}" \
		--load="${entries}" > /dev/null || die "mateconf panel default install failed"
	fi

	# Calling this late so it doesn't process the MateConf schemas file we already
	# took care of.
	mate_pkg_postinst
}

pkg_prerm() {
	local entries="${EROOT}etc/mateconf/schemas/panel-default-setup.entries"
	local mateconftool="${EROOT}usr/bin/mateconftool-2"

	if [[ -e "${entries}" ]]; then
		einfo "Removing panel mateconf defaults..."

		MATECONF_CONFIG_SOURCE="$("${mateconftool}" --get-default-source | sed "s;:/;:${ROOT};")"
		"${mateconftool}" --direct --config-source "${MATECONF_CONFIG_SOURCE}" \
		--unload="${entries}" > /dev/null || die "mateconf panel default removal failed"
	fi
}
