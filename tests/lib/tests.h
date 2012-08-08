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

#ifndef tests_h
#define tests_h

/* qerr.c */

glong qerr(quvi_t);

/* env.c */

gboolean chk_env(const gchar*, const gchar*);
gboolean chk_skip(const gchar*);
void chk_verbose(quvi_t);
gboolean chk_geoblocked();
gboolean chk_complete();
gboolean chk_fixme();
gboolean chk_nsfw();

/* Media. */

struct qm_test_exact_s
{
  const gchar *title;
  const gchar *id;
};
typedef struct qm_test_exact_s *qm_test_exact_t;

struct qm_test_opts_s
{
  struct /* String value length >0 */
  {
    struct /* stream */
    {
      struct /* video */
      {
        gboolean encoding;
      } video;
      struct /* audio */
      {
        gboolean encoding;
      } audio;
      gboolean container;
    } stream;
  } s_len_gt0;
  struct /* >0 (numeric) */
  {
    struct /* stream */
    {
      struct /* video */
      {
        gboolean bitrate_kbit_s;
        gboolean height;
        gboolean width;
      } video;
      struct
      {
        gboolean bitrate_kbit_s;
      } audio;
    } stream;
    gboolean start_time_ms;
    gboolean duration_ms;
  } gt0;
};
typedef struct qm_test_opts_s *qm_test_opts_t;

/* Compare media property string values. */
#define qm_cmp_s(qmp, e)\
  do {\
    gchar *s = NULL;\
    quvi_media_get(qm, qmp, &s);\
    g_assert_cmpint(qerr(q), ==, QUVI_OK);\
    g_assert(s != NULL);\
    g_test_message("%s=%s", #qmp, s);\
    g_assert_cmpstr(s, ==, e);\
  } while (0)

/* Media property string value length >0 */
#define qm_chk_l(qmp)\
  do {\
    gchar *s = NULL;\
    quvi_media_get(qm, qmp, &s);\
    g_assert_cmpint(qerr(q), ==, QUVI_OK);\
    g_assert(s != NULL);\
    g_test_message("%s=%s", #qmp, s);\
    g_assert_cmpint(strlen(s), >, 0);\
  } while (0)

/* Media property value (double) >0 */
#define qm_chk_gt0(qmp)\
  do {\
    gdouble v = 0;\
    quvi_media_get(qm, qmp, &v);\
    g_assert_cmpint(qerr(q), ==, QUVI_OK);\
    g_test_message("%s=%g", #qmp, v);\
    g_assert_cmpfloat(v, >, 0);\
  } while (0)

void qm_test(const gchar*, const gchar*,
             const qm_test_exact_t, const qm_test_opts_t);

/* Playlist. */

struct qp_test_exact_s
{
  const gchar *id;
};
typedef struct qp_test_exact_s *qp_test_exact_t;

struct qp_test_opts_s
{
  struct
  {
    struct
    {
      gboolean title;
    } media;
    gboolean thumbnail_url;
    gboolean title;
  } s_len_gt0;
  struct
  {
    struct
    {
      gboolean duration_ms;
    } media;
  } gt0;
};
typedef struct qp_test_opts_s *qp_test_opts_t;

/* Compare playlist property string values. */
#define qp_cmp_s(qpp, e)\
  do {\
    gchar *s = NULL;\
    quvi_playlist_get(qp, qpp, &s);\
    g_assert_cmpint(qerr(q), ==, QUVI_OK);\
    g_assert(s != NULL);\
    g_test_message("%s=%s", #qpp, s);\
    g_assert_cmpstr(s, ==, e);\
  } while (0)

/* Playist property string value length >0 */
#define qp_chk_l(qpp)\
  do {\
    gchar *s = NULL;\
    quvi_playlist_get(qp, qpp, &s);\
    g_assert_cmpint(qerr(q), ==, QUVI_OK);\
    g_assert(s != NULL);\
    g_test_message("%s=%s", #qpp, s);\
    g_assert_cmpint(strlen(s), >, 0);\
  } while (0)

/* Media property value (double) >0 */
#define qp_chk_gt0(qpp)\
  do {\
    gdouble v = 0;\
    quvi_playlist_get(qp, qpp, &v);\
    g_assert_cmpint(qerr(q), ==, QUVI_OK);\
    g_test_message("%s=%g", #qpp, v);\
    g_assert_cmpfloat(v, >, 0);\
  } while (0)

void qp_test(const gchar*, const gchar*,
             const qp_test_exact_t, const qp_test_opts_t);

/* Scan. */

struct qs_test_exact_s
{
  const gchar *url;
  const gint n; /* Expected no. of returned media URLs. */
};
typedef struct qs_test_exact_s *qs_test_exact_t;

void qs_test(const gchar*, qs_test_exact_t);

/* Other. */

gboolean match(const gchar*, const gchar*);
gchar *capture(const gchar*, const gchar*);
gchar *fetch(const gchar*);

#endif /* tests_h */

/* vim: set ts=2 sw=2 tw=72 expandtab: */
