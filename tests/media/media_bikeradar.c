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

#include "config.h"

#include <string.h>
#include <glib.h>
#include <quvi.h>

#include "tests.h"

static const gchar *URLs[] =
{
  "http://www.bikeradar.com/videos/road-bike-of-the-year-2013-roundtable-discussion-5z53s9q8zR8EM?ns_campaign=related&ns_mchannel=hl&ns_source=bikeradar&ns_linkname=0&ns_fee=0",
  "http://www.bikeradar.com/videos/trek-domane-43-road-bike-of-the-year-2013-contender-72j4s5lo1S2o0",
  "http://www.bikeradar.com/videos/ns-soda-air-first-ride-BEqx0ru02Jo7q",
  "http://www.bikeradar.com/videos/ned-boulting-on-the-giro-ditalia-2013-6vvm2cw15M60m",
  NULL
};

static const gchar *TITLEs[] =
{
  "Road Bike Of The Year 2013 Roundtable discussion",
  "Trek Domane 4.3 - Road Bike Of The Year 2013: Contender",
  "NS Soda Air - First Ride",
  "Ned Boulting On The Giro d'Italia 2013",
  NULL
};

static const gchar *IDs[] =
{
  "Xw7wrJUio3E",
  "-OWS0S1RAbo",
  "IqwgUgB2g-c",
  "afeIAyK_uMo",
  NULL
};

static void test_media_bikeradar()
{
  struct qm_test_exact_s e;
  struct qm_test_opts_s o;
  gint i;

  for (i=0; URLs[i] != NULL; ++i)
    {
      memset(&e, 0, sizeof(e));
      memset(&o, 0, sizeof(o));

      e.title = TITLEs[i];
      e.id = IDs[i];

      qm_test(__func__, URLs[i], &e, &o);
    }
}

gint main(gint argc, gchar **argv)
{
  g_test_init(&argc, &argv, NULL);
  g_test_add_func("/media/bikeradar", test_media_bikeradar);
  return (g_test_run());
}

/* vim: set ts=2 sw=2 tw=72 expandtab: */
