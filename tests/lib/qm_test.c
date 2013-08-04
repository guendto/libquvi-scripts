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

/* Test media properties. The 'e' parameter may be NULL, in which case
 * the test for exact values (e.g. title and ID) will be skipped. */
void qm_test(const gchar *func, const gchar *url,
             const qm_test_exact_t e, const qm_test_opts_t o)
{
  quvi_media_t qm;
  quvi_t q;

  if (chk_skip(func) == TRUE)
    return;

  q = quvi_new();
  g_assert(q != NULL);
  g_assert_cmpint(quvi_errcode(q), ==, QUVI_OK);

  chk_verbose(q);

  qm = quvi_media_new(q, url);
  g_test_message("errmsg=%s", quvi_errmsg(q));
  g_assert_cmpint(quvi_errcode(q), ==, QUVI_OK);
  g_assert(qm != NULL);

  if (chk_complete())
    {
      gint c;

      g_test_message("TEST_LEVEL=complete");

      /* Exact values. */

      if (e != NULL)
        {
          if (e->title != NULL)
            qm_cmp_s(QUVI_MEDIA_PROPERTY_TITLE, e->title);

          if (e->id != NULL)
            qm_cmp_s(QUVI_MEDIA_PROPERTY_ID, e->id);
        }

      /* Thumbnail, expected, but check length only. */

      qm_chk_l(QUVI_MEDIA_PROPERTY_THUMBNAIL_URL);

      /* Optional. */

      if (o->gt0.duration_ms == TRUE)
        qm_chk_gt0(QUVI_MEDIA_PROPERTY_DURATION_MS);

      if (o->gt0.start_time_ms== TRUE)
        qm_chk_gt0(QUVI_MEDIA_PROPERTY_START_TIME_MS);

      /* Streams. */

      for (c=0; quvi_media_stream_next(qm) == QUVI_TRUE; ++c);
      g_assert_cmpint(c, >, 0);

      while (quvi_media_stream_next(qm) == QUVI_TRUE)
        {
          qm_chk_l(QUVI_MEDIA_STREAM_PROPERTY_URL);

          if (c >1) /* Must have a stream ID, when there are >1 streams. */
            qm_chk_l(QUVI_MEDIA_STREAM_PROPERTY_ID);

          /* Optional. */

          if (o->s_len_gt0.stream.container == TRUE)
            qm_chk_l(QUVI_MEDIA_STREAM_PROPERTY_CONTAINER);

          /* Optional: Video. */

          if (o->gt0.stream.video.bitrate_kbit_s == TRUE)
            qm_chk_gt0(QUVI_MEDIA_STREAM_PROPERTY_VIDEO_BITRATE_KBIT_S);

          if (o->gt0.stream.video.height == TRUE)
            qm_chk_gt0(QUVI_MEDIA_STREAM_PROPERTY_VIDEO_HEIGHT);

          if (o->gt0.stream.video.width == TRUE)
            qm_chk_gt0(QUVI_MEDIA_STREAM_PROPERTY_VIDEO_WIDTH);

          if (o->s_len_gt0.stream.video.encoding == TRUE)
            qm_chk_l(QUVI_MEDIA_STREAM_PROPERTY_VIDEO_ENCODING);

          /* Optional: Audio. */

          if (o->gt0.stream.audio.bitrate_kbit_s == TRUE)
            qm_chk_gt0(QUVI_MEDIA_STREAM_PROPERTY_AUDIO_BITRATE_KBIT_S);

          if (o->s_len_gt0.stream.audio.encoding == TRUE)
            qm_chk_l(QUVI_MEDIA_STREAM_PROPERTY_AUDIO_ENCODING);
        }
    }
  else
    {
      g_test_message("TEST_LEVEL=basic");

      /* Must return >0 media streams. */

      qm_chk_l(QUVI_MEDIA_STREAM_PROPERTY_URL);
    }

  quvi_media_free(qm);
  quvi_free(q);
}

/* vim: set ts=2 sw=2 tw=72 expandtab: */
