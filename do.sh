#!/bin/sh

for i in ./*/*/*.ebuild;
	do
		sed -i 1,3d "${i}";
		sed -i '1i\# Copyright 1999-2012 Gentoo Foundation' "${i}";
		sed -i '2i\# Distributed under the terms of the GNU General Public License v2' "${i}";
		sed -i '3i\# $Header: $' "${i}";
		FEATURES="-mini-manifest" ebuild "${i}" manifest;
	done
