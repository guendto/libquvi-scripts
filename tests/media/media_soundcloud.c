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

static const gchar URL[] =
  "http://soundcloud.com/nishinverdiano/danilo-garcia-feat-laura";

static const gchar TITLE[] =
  "Danilo Garcia feat. Laura Brehm - I Remember You (Nishin Verdiano Remix)";

static const gchar ID[] =
  "ZxCn4F6fjP9J";

static void test_media_soundcloud()
{
  struct qm_test_exact_s e;
  struct qm_test_opts_s o;

  memset(&e, 0, sizeof(e));
  memset(&o, 0, sizeof(o));

  e.title = TITLE;
  e.id = ID;

  o.gt0.duration_ms = TRUE;

  qm_test(__func__, URL, &e, &o);
}

gint main(gint argc, gchar **argv)
{
  g_test_init(&argc, &argv, NULL);
  g_test_add_func("/media/soundcloud", test_media_soundcloud);
  return (g_test_run());
}

/* vim: set ts=2 sw=2 tw=72 expandtab: */
