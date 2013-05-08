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

/*
 * NOTE
 *
 * Media hosted at ardmediathek.de will reportedly expire after a few
 * weeks. This test attempts to work around this by trying to find a
 * media URL from the website that can be used to test the media script.
 *
 * The front page will not contain any media URLs unless javascript is
 * enabled. We cannot emulate js so, instead, we fetch the "Neueste
 * Clips" which should media URLs.
 */

#include "config.h"

#include <string.h>
#include <glib.h>
#include <quvi.h>

#include "tests.h"

static const gchar WWW[] = "http://www.ardmediathek.de";

static gchar *fetch_neueste_clips_page()
{
  static const gchar PATTERN[] =
    "href=\"(.*)\" title=\".*\" data-xtclib=\"Neueste\\+Clips\"";

  gchar *p, *u, *s;
  capture_t c;

  p = fetch(WWW);
  g_assert(p != NULL);

  c = capture_new(p, PATTERN, 0);
  g_assert(c != NULL);

  g_assert(capture_matches(c) == TRUE);
  s = capture_fetch(c, 1);

  capture_free(c);
  g_free(p);

  u = g_strdup_printf("%s%s", WWW, s);
  g_free(s);

  p = fetch(u);
  g_free(u);

  return (p);
}

static void test_media_ardmediathek()
{
  static const gchar PATTERN[] = "href=\"(.*documentId=.*)\" class";

  struct qm_test_opts_s o;
  gchar *p, *u, *r;
  capture_t c;
  GSList *l;

  memset(&o, 0, sizeof(o));

  /* Normally done in qm_test, due to fetch-parse, do it here. */

  if (chk_skip(__func__) == TRUE)
    return;

  p = fetch_neueste_clips_page();
  g_assert(p != NULL);

  l = NULL;
  u = NULL;

  c = capture_new(p, PATTERN, 0);
  g_assert(c != NULL);

  while (capture_matches(c) == TRUE)
    {
      r = capture_fetch(c, 1);
      l = g_slist_prepend(l, g_strdup_printf("%s%s", WWW, r));
      capture_next(c);
      g_free(r);
    }
  l = g_slist_reverse(l);
  g_assert_cmpint(g_slist_length(l), >, 0);

  /* Pick a random URL from the stack. */
  {
    const gint32 n = g_random_int_range(0, g_slist_length(l));
    u = (gchar*) g_slist_nth_data(l, n);
  }
  g_assert(u != NULL);

  g_test_message("media URL=%s", u);
  qm_test(__func__, u, NULL, &o);

  slist_free_full(l, (GFunc) g_free);
  capture_free(c);
  g_free(p);
}

gint main(gint argc, gchar **argv)
{
  g_test_init(&argc, &argv, NULL);
  g_test_add_func("/media/ardmediathek", test_media_ardmediathek);
  return (g_test_run());
}

/* vim: set ts=2 sw=2 tw=72 expandtab: */
