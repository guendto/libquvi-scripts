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

#include <glib.h>
#include "tests.h"

#define _W "%s: %s"

gboolean match(const gchar *s, const gchar *p)
{
  GMatchInfo *m;
  GError *err;
  GRegex *re;
  gboolean r;

  err = NULL;
  re = g_regex_new(p, G_REGEX_MULTILINE, 0, &err);

  if (err != NULL)
    {
      g_warning(_W, __func__, err->message);
      g_error_free(err);
      return (FALSE);
    }

  m = NULL;
  r = g_regex_match(re, s, 0, &m);

  g_match_info_free(m);
  m = NULL;

  g_regex_unref(re);
  re = NULL;

  return (r);
}

capture_t capture_new(const gchar *str, const gchar *patt,
                      const GRegexCompileFlags flags)
{
  capture_t p = g_new0(struct capture_s, 1);

  p->re = g_regex_new(patt, flags, 0, &p->e);
  if (p->e != NULL)
    {
      g_warning(_W, __func__, p->e->message);
      capture_free(p);
      return (NULL);
    }

  g_regex_match_full(p->re, str, -1, 0, 0, &p->m, &p->e);
  if (p->e != NULL)
    {
      g_warning(_W, __func__, p->e->message);
      capture_free(p);
      return (NULL);
    }
  return (p);
}

gboolean capture_matches(capture_t p)
{
  g_assert(p != NULL);
  g_assert(p->m != NULL);
  return (g_match_info_matches(p->m));
}

gchar *capture_fetch(capture_t p, const gint i)
{
  g_assert(p != NULL);
  g_assert(p->m != NULL);
  return (g_match_info_fetch(p->m, i));
}

gboolean capture_next(capture_t p)
{
  g_assert(p != NULL);
  g_assert(p->m != NULL);

  g_match_info_next(p->m, &p->e);
  if (p->e != NULL)
    {
      g_warning(_W, __func__, p->e->message);
      return (FALSE);
    }
  return (TRUE);
}

void capture_free(capture_t p)
{
  if (p == NULL)
    return;

  g_match_info_free(p->m);
  g_regex_unref(p->re);

  if (p->e != NULL)
    g_error_free(p->e);

  g_free(p);
}

/* vim: set ts=2 sw=2 tw=72 expandtab: */
