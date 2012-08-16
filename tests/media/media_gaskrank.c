/* libquvi-scripts
 * Copyright (C) 2012  Toni Gundogdu <legatvs@gmail.com>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
 * 02110-1301, USA.
 */

#include "config.h"

#include <string.h>
#include <glib.h>
#include <quvi.h>

#include "tests.h"

static const gchar URL[] =
  "http://www.gaskrank.tv/tv/motorrad-oldtimer/1928-henderson-deluxe-alt-und--19115.htm";

static const gchar TITLE[] =
  "1928 Henderson Deluxe - alt und mit der Patina des Alters aber läuft";

static const gchar ID[] =
  "19115";

static void test_media_gaskrank()
{
  struct qm_test_exact_s e;
  struct qm_test_opts_s o;

  memset(&e, 0, sizeof(e));
  memset(&o, 0, sizeof(o));

  e.title = TITLE;
  e.id = ID;

  qm_test(__func__, URL, &e, &o);
}

gint main(gint argc, gchar **argv)
{
  g_test_init(&argc, &argv, NULL);
  g_test_add_func("/media/gaskrank", test_media_gaskrank);
  return (g_test_run());
}

/* vim: set ts=2 sw=2 tw=72 expandtab: */
