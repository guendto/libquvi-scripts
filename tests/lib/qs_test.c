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

void qs_test(const gchar *func, const qs_test_exact_t qste)
{
  const gchar *s;
  quvi_scan_t qs;
  quvi_t q;
  gint c;

  if (chk_skip(func) == TRUE)
    return;

  q = quvi_new();
  g_assert(q != NULL);
  g_assert_cmpint(quvi_errcode(q), ==, QUVI_OK);

  chk_verbose(q);

  g_test_message("url=%s", qste->url);

  qs = quvi_scan_new(q, qste->url);
  g_test_message("errmsg=%s", quvi_errmsg(q));
  g_assert_cmpint(quvi_errcode(q), ==, QUVI_OK);
  g_assert(qs != NULL);

  for (c=0; (s = quvi_scan_next_media_url(qs)) != NULL; ++c)
    {
      g_test_message("media URL=%s", s);
      g_assert_cmpint(strlen(s), >, 0);
    }
  g_assert_cmpint(c, ==, qste->n);

  quvi_scan_free(qs);
  quvi_free(q);
}

/* vim: set ts=2 sw=2 tw=72 expandtab: */
