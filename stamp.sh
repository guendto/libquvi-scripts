#!/bin/sh
#
# libquvi-scripts
# Copyright (C) 2012  Toni Gundogdu <legatvs@gmail.com>
#
# This file part of libquvi-scripts <http://quvi.sourceforge.net/>.
#
# This program is free software: you can redistribute it and/or
# modify it under the terms of the GNU Affero General Public
# License as published by the Free Software Foundation, either
# version 3 of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General
# Public License along with this program.  If not, see
# <http://www.gnu.org/licenses/>.
#
top_distdir=$2
VN=$1

help()
{
  echo "Usage: $0 <version> <top_distdir>"
  exit 1
}

stamp_scripts()
{
  [ -z "$VN" ] && {
    echo error: define version string
    help
  }
  [ -z "$top_distdir" ] && {
    echo error: define path to top dist dir
    help
  }
  [ -x "$top_distdir/gen-ver.sh" ] && {
    echo "Stamp lua scripts..."
    D='common/ media/ playlist/ scan/ util/'
    for d in $D; do
      find "$top_distdir/share/$d" -name '*.lua' \
        -exec echo "Stamp {}" \; \
        -exec sed -i "s/^\(-- libquvi-scripts\).*/\1 $VN/" {} \;
    done
  }
  exit 0
}

stamp_scripts
