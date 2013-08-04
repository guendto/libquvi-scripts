/* libquvi-scripts
 * Copyright (C) 2013  Toni Gundogdu <legatvs@gmail.com>
 *
 * This file is part of libquvi-scripts <http://quvi.sourceforge.net/>.
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

static void _test_basic(const gchar *func, const gchar *url,
                        qsub_test_opts_t o, quvi_t q, quvi_subtitle_t qsub)
{
  quvi_subtitle_type_t qst;
  quvi_subtitle_lang_t qsl;
  gint t,l;

  /* Must return >0 subtitle types. */

  for (t=0; (qst = quvi_subtitle_type_next(qsub)) != NULL; ++t)
    {
      gdouble type;

      /* Must set the type properties. */

      qsub_chk_type_gt0(QUVI_SUBTITLE_TYPE_PROPERTY_FORMAT);
      qsub_chk_type_gt0(QUVI_SUBTITLE_TYPE_PROPERTY_TYPE);

      quvi_subtitle_type_get(qst, QUVI_SUBTITLE_TYPE_PROPERTY_TYPE, &type);

      /* Must return >0 subtitle langs. */

      for (l=0; (qsl = quvi_subtitle_lang_next(qst)) != NULL; ++l)
        {
          /* Must set the lang properties. */

          qsub_chk_lang_l(QUVI_SUBTITLE_LANG_PROPERTY_CODE);
          qsub_chk_lang_l(QUVI_SUBTITLE_LANG_PROPERTY_URL);
          qsub_chk_lang_l(QUVI_SUBTITLE_LANG_PROPERTY_ID);

          /*
           * YouTube provides these properties for CCs only. If additional
           * subtitle scripts are introduced, this needs to be reworked.
           */
          if (type == QUVI_SUBTITLE_TYPE_CC)
            {
              if (o->lang.s_len_gt0.translated == TRUE)
                qsub_chk_lang_l(QUVI_SUBTITLE_LANG_PROPERTY_TRANSLATED);

              if (o->lang.s_len_gt0.original == TRUE)
                qsub_chk_lang_l(QUVI_SUBTITLE_LANG_PROPERTY_ORIGINAL);
            }
        }
      g_assert_cmpint(l, >, 0);
    }
  g_assert_cmpint(t, >, 0);
}

/*
 * Test subtitle properties.
 */
void qsub_test(const gchar *func, const gchar *url, qsub_test_opts_t o)
{
  quvi_subtitle_t qsub;
  quvi_t q;

  if (chk_skip(func) == TRUE)
    return;

  q = quvi_new();
  g_assert(q != NULL);
  g_assert_cmpint(quvi_errcode(q), ==, QUVI_OK);

  chk_verbose(q);

  qsub = quvi_subtitle_new(q, url);
  g_test_message("errmsg=%s", quvi_errmsg(q));
  g_assert_cmpint(quvi_errcode(q), ==, QUVI_OK);
  g_assert(qsub != NULL);

  /* Both levels are identical. */
  if (chk_complete())
    {
      g_test_message("TEST_LEVEL=complete");
      _test_basic(func, url, o, q, qsub);
    }
  else
    {
      g_test_message("TEST_LEVEL=basic");
      _test_basic(func, url, o, q, qsub);
    }
  quvi_subtitle_free(qsub);
  quvi_free(q);
}

/* vim: set ts=2 sw=2 tw=72 expandtab: */
