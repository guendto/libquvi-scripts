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

static const gchar URL[] = "http://youtube.com/watch?v=0QRO3gKj3qw";

static void test_subtitle_youtube_core()
{
  struct qsub_test_opts_s o;

  memset(&o, 0, sizeof(o));

  /* type */

  o.type.gt0.format = TRUE;
  o.type.gt0.type = TRUE;

  /* lang */

  o.lang.s_len_gt0.translated = TRUE; /* cc only */
  o.lang.s_len_gt0.original = TRUE; /* cc only */
  o.lang.s_len_gt0.code = TRUE;
  o.lang.s_len_gt0.url = TRUE;
  o.lang.s_len_gt0.id = TRUE;

  qsub_test(__func__, URL, &o);
}

static void _test_subrip(quvi_t q, quvi_subtitle_t qsub, const gchar *lang)
{
  quvi_subtitle_export_t qse;
  quvi_subtitle_lang_t qsl;
  gchar *s;

  qsl = quvi_subtitle_select(qsub, lang);
  g_assert_cmpint(quvi_errcode(q), ==, QUVI_OK);
  g_assert(qsl != NULL);

  quvi_subtitle_lang_get(qsl, QUVI_SUBTITLE_LANG_PROPERTY_ID, &s);
  g_test_message("lang_id=%s", s);

  qse = quvi_subtitle_export_new(qsl, "srt");
  g_assert_cmpint(quvi_errcode(q), ==, QUVI_OK);
  g_assert(qse != NULL);

  g_test_message("subrip_data=%s", quvi_subtitle_export_data(qse));
  g_assert_cmpint(strlen(quvi_subtitle_export_data(qse)), >, 4096);

  quvi_subtitle_export_free(qse);
}

static void test_subtitle_youtube_export()
{
  quvi_subtitle_t qsub;
  quvi_t q;

  if (chk_skip(__func__) == TRUE)
    return;

  q = quvi_new();
  g_assert(q != NULL);
  g_assert_cmpint(quvi_errcode(q), ==, QUVI_OK);

  chk_verbose(q);

  qsub = quvi_subtitle_new(q, URL);
  g_test_message("errmsg=%s", quvi_errmsg(q));
  g_assert_cmpint(quvi_errcode(q), ==, QUVI_OK);
  g_assert(qsub != NULL);

  _test_subrip(q, qsub, "tts_en,croak");
  _test_subrip(q, qsub, "cc_en,croak");

  quvi_subtitle_free(qsub);
  quvi_free(q);
}

gint main(gint argc, gchar **argv)
{
  g_test_init(&argc, &argv, NULL);

  g_test_add_func("/subtitle/youtube (core)",
                  test_subtitle_youtube_core);

  g_test_add_func("/subtitle/youtube (export, subrip)",
                  test_subtitle_youtube_export);

  return (g_test_run());
}

/* vim: set ts=2 sw=2 tw=72 expandtab: */
