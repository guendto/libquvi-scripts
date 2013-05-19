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
  "http://soundcloud.com/volt-icarus2-otherupload/sets/bgm/";

static const gchar ID[] =
  "volt-icarus2-otherupload_bgm";

static void test_playlist_soundcloud()
{
  struct qp_test_exact_s e;
  struct qp_test_opts_s o;

  memset(&e, 0, sizeof(e));
  memset(&o, 0, sizeof(o));

  e.id = ID;

  /* String values. */

  o.s_len_gt0.thumbnail_url = TRUE;
  o.s_len_gt0.title = TRUE;

  o.s_len_gt0.media.title = TRUE;

  /* Numerical values. */

  o.gt0.media.duration_ms = TRUE;

  qp_test(__func__, URL, &e, &o);
}

gint main(gint argc, gchar **argv)
{
  g_test_init(&argc, &argv, NULL);
  g_test_add_func("/playlist/soundcloud", test_playlist_soundcloud);
  return (g_test_run());
}

/* vim: set ts=2 sw=2 tw=72 expandtab: */
