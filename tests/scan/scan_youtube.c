/* libquvi-scripts
 * Copyright (C) 2012  Toni Gundogdu <legatvs@gmail.com>
 *
 * This file is part of libquvi-scripts <http://quvi.sourceforge.net>.
 *
 * This program is free software: you can redistribute it and/or
 * modify it under the terms of the GNU Affero General Public
 * License as published by the Free Software Foundation, either
 * version 3 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General
 * Public License along with this program.  If not, see
 * <http://www.gnu.org/licenses/>.
 */

#include "config.h"

#include <string.h>
#include <glib.h>
#include <quvi.h>

#include "tests.h"

static const struct qs_test_exact_s qste[] =
{
  {"http://eupodiatamatando.com/2010/10/19/voce-nao-sabe-fazer-um-cha-ele-sabe/", 1},
  {"http://screenrant.com/superman-man-steel-trailer/", 2},
  {"http://is.gd/eptmIb", 2},
  {NULL, 0}
};

static void test_scan_youtube()
{
  gint i;
  for (i=0; qste[i].url != NULL; ++i)
    qs_test(__func__, (qs_test_exact_t) &qste[i]);
}

gint main(gint argc, gchar **argv)
{
  g_test_init(&argc, &argv, NULL);
  g_test_add_func("/scan/youtube", test_scan_youtube);
  return (g_test_run());
}

/* vim: set ts=2 sw=2 tw=72 expandtab: */
