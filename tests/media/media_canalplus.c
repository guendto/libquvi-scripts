/* libquvi-scripts
 * Copyright (C) 2013  Mohamed El Morabity <melmorabity@fedoraproject.org>
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
  "http://www.canalplus.fr/c-sport/c-football/c-football-coupe-du-monde-2014/pid3610-c-videos-cdm-2014.html?vid=973283",
  "http://www.d8.tv/c-divertissement/d8-palmashow/pid5036-vbb-saison-2.html?vid=776533",
  "http://www.d17.tv/docs-mags/pid6273-musique.html?vid=933914",
  NULL
};

static const gchar *TITLEs[] =
{
  "Coupe du Monde 2014",
  "Very Bad Blagues - Saison 2",
  "Pink Floyd : Behind «the wall»",
  NULL
};

static const gchar *IDs[] =
{
  "973283",
  "776533",
  "933914",
  NULL
};

static void test_media_canalplus()
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
  g_test_add_func("/media/canalplus", test_media_canalplus);
  return (g_test_run());
}

/* vim: set ts=2 sw=2 tw=72 expandtab: */
