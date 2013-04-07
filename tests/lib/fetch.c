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
#include <curl/curl.h>

#include "tests.h"

struct temp_s
{
  gsize size;
  gchar *p;
};
typedef struct temp_s *temp_t;

static gpointer temp_new()
{
  return (g_new0(struct temp_s, 1));
}

static void temp_free(temp_t t)
{
  if (t == NULL)
    return;

  g_free(t->p);
  t->p = NULL;

  g_free(t);
  t = NULL;
}

/* cURL write callback. */
static gsize temp_wrcb(gpointer p, gsize sz, gsize nmemb, gpointer d)
{
  const gsize rsize = sz*nmemb;
  gpointer *np;
  temp_t t;

  t = (temp_t) d;
  np = g_realloc(t->p, t->size+rsize+1);

  if (np != NULL)
    {
      t->p = (gchar*) np;
      memcpy(&(t->p[t->size]), p, rsize);
      t->size += rsize;
      t->p[t->size] = '\0';
    }
  return (rsize);
}

static void set_opts(CURL *c, temp_t t, const gchar *url)
{
  typedef curl_write_callback cwc;

  curl_easy_setopt(c, CURLOPT_USERAGENT, "Mozilla/5.0");
  curl_easy_setopt(c, CURLOPT_FOLLOWLOCATION, 1L);
  curl_easy_setopt(c, CURLOPT_MAXREDIRS, 5L); /* http://is.gd/kFsvE4 */
  curl_easy_setopt(c, CURLOPT_NOBODY, 0L);

  curl_easy_setopt(c, CURLOPT_WRITEFUNCTION, (cwc) temp_wrcb);
  curl_easy_setopt(c, CURLOPT_URL, url);
  curl_easy_setopt(c, CURLOPT_WRITEDATA, t);
  /* CURLOPT_ENCODING -> CURLOPT_ACCEPT_ENCODING 7.21.6+ */
  curl_easy_setopt(c, CURLOPT_ENCODING, "");

  if (chk_env("TEST_VERBOSE", NULL) == TRUE)
    curl_easy_setopt(c, CURLOPT_VERBOSE, 1L);
}

static void reset_opts(CURL *c)
{
  curl_easy_setopt(c, CURLOPT_WRITEFUNCTION, NULL);
  curl_easy_setopt(c, CURLOPT_WRITEDATA, NULL);
}

static gint _fetch(CURL *c)
{
  CURLcode curlcode;
  glong respcode;
  gint rc;

  curlcode = curl_easy_perform(c);
  curl_easy_getinfo(c, CURLINFO_RESPONSE_CODE, &respcode);

  rc = 0;

  if (curlcode == CURLE_OK && respcode == 200)
    ;
  else
    {
      if (curlcode == CURLE_OK)
        {
#define _EOK "server responded with code %03ld"
          g_test_message(_EOK, respcode);
#undef _EOK
        }
      else
        {
          const gchar *s = curl_easy_strerror(curlcode);
          const glong c = respcode;
          const gint cc = curlcode;
#define _ENO "%s (HTTP/%03ld, cURL=0x%03x)"
          g_test_message(_ENO, s, c, cc);
#undef _ENO
        }
      rc = 1;
    }
  return (rc);
}

gchar *fetch(const gchar *url)
{
  gchar *r;
  temp_t t;
  CURL *c;
  gint rc;

  curl_global_init(CURL_GLOBAL_ALL);

  c = curl_easy_init();
  if (c == NULL)
    {
      g_message("curl_easy_init returned NULL");
      return (NULL);
    }

  t = temp_new();
  r = NULL;

  set_opts(c, t, url);
  rc = _fetch(c);
  reset_opts(c);

  if (rc == 0)
    r = g_strdup(t->p);

  temp_free(t);
  t = NULL;

  curl_easy_cleanup(c);
  c = NULL;

  curl_global_cleanup();

  return (r);
}

/* vim: set ts=2 sw=2 tw=72 expandtab: */
