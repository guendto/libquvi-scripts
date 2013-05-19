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

static const gchar *URLs[] =
{
  /* with underscore. */
  "http://www.youtube.com/playlist?list=PLlbnzwCkgkTBBXWz595XaKs_kkXek0gQP",
  /* with dash. */
  "http://www.youtube.com/playlist?list=PLn83-N7Bdu2aHMVgBPoJfr0gmvXLVBMlF",
  /* with '&'. */
  "http://www.youtube.com/playlist?list=PLEE6E4AF38BC19EC2&",
  /* with "SP". */
  "http://www.youtube.com/playlist?list=SP1C90BDF46E6EACFD",
  /* shortened. */
  "http://is.gd/B4BBAA",
  NULL
};

static const gchar *IDs[] =
{
  "PLlbnzwCkgkTBBXWz595XaKs_kkXek0gQP",
  "PLn83-N7Bdu2aHMVgBPoJfr0gmvXLVBMlF",
  "PLEE6E4AF38BC19EC2",
  "SP1C90BDF46E6EACFD",
  "PL5BF9E09ECEC8F88F",
  NULL
};

static void test_playlist_youtube()
{
  struct qp_test_exact_s e;
  struct qp_test_opts_s o;
  gint i;

  for (i=0; URLs[i] != NULL && IDs[i] != NULL; ++i)
    {
      memset(&e, 0, sizeof(e));
      memset(&o, 0, sizeof(o));

      /* Exact values. */

      e.id = IDs[i];

      /* Optional */

      o.s_len_gt0.thumbnail_url = TRUE;
      o.s_len_gt0.title = TRUE;

      o.s_len_gt0.media.title = TRUE;
      o.gt0.media.duration_ms = TRUE;

      qp_test(__func__, URLs[i], &e, &o);
    }
}

gint main(gint argc, gchar **argv)
{
  g_test_init(&argc, &argv, NULL);
  g_test_add_func("/playlist/youtube", test_playlist_youtube);
  return (g_test_run());
}

/* vim: set ts=2 sw=2 tw=72 expandtab: */
