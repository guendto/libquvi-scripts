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
  "http://www.theguardian.com/film/video/2013/aug/01/alan-partridge-alpha-papa-video",
  "http://www.guardian.co.uk/football/blog/audio/2013/feb/18/football-weekly-blackburn-arsenal-wenger",
  "http://www.guardian.co.uk/technology/video/2013/may/01/google-glass-user-guide-released-video",
  "http://www.guardian.co.uk/science/audio/2013/apr/29/podcast-science-weekly-burning-question",
  "http://www.guardian.co.uk/football/blog/audio/2013/apr/29/football-weekly-podcast-qpr-reading-relegated-newcastle",
  NULL
};

static const gchar *TITLEs[] =
{
  "Alan Partridge: Alpha Papa: watch an exclusive clip",
  "Football Weekly: Blackburn dump Arsenal out of the FA Cup",
  "Google Glass: video user guide released – video",
  "Science Weekly podcast: The Burning Question – can we quit fossil fuels?",
  "Football Weekly: QPR and Reading relegated - will Newcastle join them?",
  NULL
};

static const gchar *IDs[] =
{
  "1945044",
  "1869215",
  "1902069",
  "1899845",
  "1900820",
  NULL
};

static void test_media_guardian()
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

#ifdef _1 /* Skip: audio streams don't obviously have these */
      o.gt0.stream.video.height = TRUE;
      o.gt0.stream.video.width = TRUE;
#endif
      o.gt0.duration_ms = TRUE;

      qm_test(__func__, URLs[i], &e, &o);
    }
}

gint main(gint argc, gchar **argv)
{
  g_test_init(&argc, &argv, NULL);
  g_test_add_func("/media/guardian", test_media_guardian);
  return (g_test_run());
}

/* vim: set ts=2 sw=2 tw=72 expandtab: */
