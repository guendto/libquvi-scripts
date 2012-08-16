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

/* NOTE: Media hosted at videos.arte.tv expire after some time. For this
 * test, we need to fetch the front page and parse a test media URL from
 * it. */

#include "config.h"

#include <string.h>
#include <glib.h>
#include <quvi.h>

#include "tests.h"

static const gchar FIRST[] = "\\<h2\\>\\<a href=\"(.*)\"";
static const gchar WWW[] = "http://videos.arte.tv";

static void test_media_arte()
{
  struct qm_test_opts_s o;
  gchar *c, *p, *url;

  memset(&o, 0, sizeof(o));

  if (chk_geoblocked() == FALSE)
    return;

  /* Normally done in qm_test but due to the fetch-parse circumstances,
   * do it here. */
  if (chk_skip(__func__) == TRUE)
    return;

  c = fetch(WWW);
  g_assert(c != NULL);

  p = capture(c, FIRST);
  g_assert(p != NULL);

  g_free(c);
  c = NULL;

  url = g_strdup_printf("%s%s", WWW, p);
  g_test_message("media URL=%s", url);

  g_free(p);
  p = NULL;

  qm_test(__func__, url, NULL, &o);

  g_free(url);
  url = NULL;
}

gint main(gint argc, gchar **argv)
{
  g_test_init(&argc, &argv, NULL);
  g_test_add_func("/media/arte", test_media_arte);
  return (g_test_run());
}

/* vim: set ts=2 sw=2 tw=72 expandtab: */
