/* libquvi-scripts
 * Copyright (C) 2013  Toni Gundogdu <legatvs@gmail.com>
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

static const gchar *URLs[] =
{
  "http://www.lego.com/en-us/videos?video={F1126563-A96C-4561-93D0-7048143BF4C0}",
  "http://www.lego.com/en-us/city/movies/fan-created/truckload-of-cash",
  "http://city.lego.com/en-us/movies/mini-movies/museum-heist/",
  NULL
};

static const gchar *TITLEs[] =
{
  "Brain Attack Episode 10",
  "Truckload of Cash",
  "Museum Heist",
  NULL
};

static const gchar *IDs[] =
{
  "f1126563-a96c-4561-93d0-7048143bf4c0",
  "5d7e7177-ee51-463b-b0fb-fe2abd2e19ac",
  "3ef1b044-126f-4833-b9fb-0371595d25f9",
  NULL
};

static void test_media_lego()
{
  struct qm_test_exact_s e;
  struct qm_test_opts_s o;
  gint i;

  for (i=0; URLs[i] != NULL; ++i)
    {
      memset(&e, 0, sizeof(e));
      memset(&o, 0, sizeof(o));

      e.title = TITLEs[i];
      e.id = IDs[i];

      qm_test(__func__, URLs[i], &e, &o);
    }
}

gint main(gint argc, gchar **argv)
{
  g_test_init(&argc, &argv, NULL);
  g_test_add_func("/media/lego", test_media_lego);
  return (g_test_run());
}

/* vim: set ts=2 sw=2 tw=72 expandtab: */
