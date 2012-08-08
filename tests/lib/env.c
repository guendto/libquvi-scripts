/* libquvi-scripts
 * Copyright (C) 2012  Toni Gundogdu <legatvs@gmail.com>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
 * 02110-1301, USA.
 */

#include "config.h"

#include <string.h>
#include <glib.h>
#include <quvi.h>
#include <curl/curl.h>

#include "tests.h"

gboolean chk_env(const gchar *w, const gchar *m)
{
  const gchar *s = g_getenv(w);
  if (s == NULL || strlen(s) == 0)
    {
      if (m != NULL)
        g_test_message("%s", m);
      return (FALSE);
    }
  return (TRUE);
}

gboolean chk_nsfw()
{
  return (chk_env("TEST_NSFW", "SKIP: Set TEST_NSFW to enable"));
}

gboolean chk_fixme()
{
  return (chk_env("TEST_FIXME", "SKIP: Set TEST_FIXME to enable"));
}

void chk_verbose(quvi_t q)
{
  g_assert(q != NULL);
  if (chk_env("TEST_VERBOSE", NULL) == TRUE)
    {
      CURL *c = NULL;
      quvi_get(q, QUVI_INFO_CURL_HANDLE, &c);
      curl_easy_setopt(c, CURLOPT_VERBOSE, 1L);
    }
}

static gboolean chk_level(const gchar *s)
{
  const gchar *e = g_getenv("TEST_LEVEL");

  if (e == NULL || strlen(e) == 0)
    return (FALSE);

  return ((g_strcmp0(e, s) == 0) ? TRUE:FALSE);
}

gboolean chk_complete()
{
  return (chk_level("complete"));
}

gboolean chk_skip(const gchar *test)
{
  const gchar *e = g_getenv("TEST_SKIP");
  gboolean r = FALSE;

  if (e == NULL || strlen(e) == 0)
    return (FALSE);
  {
    gchar **s = g_strsplit(e, ",", 0);
    gint i = -1;

    while (s != NULL && s[++i] != NULL)
      {
        if (match(test, s[i]) == TRUE)
          {
            g_test_message("SKIP: Remove '%s' from TEST_SKIP to enable",
                           test);
            r = TRUE;
            break;
          }
      }
    g_strfreev(s);
    s = NULL;
  }
  return (r);
}

/* vim: set ts=2 sw=2 tw=72 expandtab: */
