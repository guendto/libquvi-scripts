/* libquvi-scripts
 * Copyright (C) 2012,2013  Toni Gundogdu <legatvs@gmail.com>
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

/* Test playlist properties. The 'e' parameter may be NULL, in which
 * case the test for the exact values (e.g. ID) will be skipped. */
void qp_test(const gchar *func, const gchar *url,
             const qp_test_exact_t e, const qp_test_opts_t o)
{
  quvi_playlist_t qp;
  quvi_t q;
  gint c;

  if (chk_skip(func) == TRUE)
    return;

  q = quvi_new();
  g_assert(q != NULL);
  g_assert_cmpint(quvi_errcode(q), ==, QUVI_OK);

  chk_verbose(q);

  qp = quvi_playlist_new(q, url);
  g_test_message("errmsg=%s", quvi_errmsg(q));
  g_assert_cmpint(quvi_errcode(q), ==, QUVI_OK);
  g_assert(qp != NULL);

  if (chk_complete())
    {
      g_test_message("TEST_LEVEL=complete");

      /* Exact values. */

      if (e != NULL)
        {
          if (e->id != NULL)
            qp_cmp_s(QUVI_PLAYLIST_PROPERTY_ID, e->id);
        }

      /* Optional. */

      if (o->s_len_gt0.thumbnail_url == TRUE)
        qp_chk_l(QUVI_PLAYLIST_PROPERTY_THUMBNAIL_URL);

      if (o->s_len_gt0.title == TRUE)
        qp_chk_l(QUVI_PLAYLIST_PROPERTY_TITLE);

      /* Media. */

      c = 0;
      while (quvi_playlist_media_next(qp) == QUVI_TRUE)
        {
          qp_chk_l(QUVI_PLAYLIST_MEDIA_PROPERTY_URL);

          /* Optional. */

          if (o->gt0.media.duration_ms == TRUE)
            qp_chk_gt0(QUVI_PLAYLIST_MEDIA_PROPERTY_DURATION_MS);

          if (o->s_len_gt0.media.title == TRUE)
            qp_chk_l(QUVI_PLAYLIST_MEDIA_PROPERTY_TITLE);

          ++c;
        }
      g_assert_cmpint(c, >, 0);
    }
  else
    {
      g_test_message("TEST_LEVEL=basic");

      /* Must return >0 media URLs. */

      for (c=0; quvi_playlist_media_next(qp) == QUVI_TRUE; ++c)
        {
          qp_chk_l(QUVI_PLAYLIST_MEDIA_PROPERTY_URL);
        }
      g_assert_cmpint(c, >, 0);
    }

  quvi_playlist_free(qp);
  quvi_free(q);
}

/* vim: set ts=2 sw=2 tw=72 expandtab: */
