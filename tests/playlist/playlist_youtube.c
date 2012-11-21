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
  "http://www.youtube.com/watch?v=p5o7gBKHwtk&list=PL954CCC04F8437E14&feature=plcp",
  "http://www.youtube.com/watch?v=AAfpq6EPKck&feature=list_related&playnext=1&list=SP1C90BDF46E6EACFD",
  "http://www.youtube.com/playlist?list=PLEE6E4AF38BC19EC2",
  "http://www.youtube.com/playlist?list=PLAAF3A1D0CA1E304F",
  "http://is.gd/B4BBAA",
  "http://www.youtube.com/watch?v=XIKFORGW3Ig&list=PL2484FAEB06A4FB74&",
  "http://www.youtube.com/playlist?list=PL5BF9E09ECEC8F88F",
  NULL
};

static const gchar *IDs[] =
{
  "954CCC04F8437E14",
  "1C90BDF46E6EACFD",
  "EE6E4AF38BC19EC2",
  "AAF3A1D0CA1E304F",
  "5BF9E09ECEC8F88F",
  "2484FAEB06A4FB74",
  "5BF9E09ECEC8F88F",
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

#ifdef _NOT_IMPLEMENTED_IN_PLAYLIST_YOUTUBE_LUA
      /* Optional: string values */

      o.s_len_gt0.thumbnail_url = TRUE;
      o.s_len_gt0.title = TRUE;

      o.s_len_gt0.media.title = TRUE;

      /* Optional: numerical values */

      o.gt0.media.duration_ms = TRUE;
#endif
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
