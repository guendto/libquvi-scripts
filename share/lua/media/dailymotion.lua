-- libquvi-scripts
-- Copyright (C) 2010-2012  Toni Gundogdu <legatvs@gmail.com>
--
-- This file is part of libquvi-scripts <http://quvi.sourceforge.net/>.
--
-- This library is free software; you can redistribute it and/or
-- modify it under the terms of the GNU Lesser General Public
-- License as published by the Free Software Foundation; either
-- version 2.1 of the License, or (at your option) any later version.
--
-- This library is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
-- Lesser General Public License for more details.
--
-- You should have received a copy of the GNU Lesser General Public
-- License along with this library; if not, write to the Free Software
-- Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
-- 02110-1301  USA
--

-- "http://dai.ly/cityofscars",
-- "http://www.dailymotion.com/video/xdpig1_city-of-scars_shortfilms",

local Dailymotion = {} -- Utility functions unique to this script.

-- Identify the media script.
function ident(qargs)
  local A = require 'quvi/accepts'
  local C = require 'quvi/const'
  local d = {"dailymotion%.%w+", "dai.ly"} -- domains
  local p = {"/video/", "/%w+$", "/family_filter"} -- paths
  local r = {
    accepts = A.accepts(qargs.input_url, d, p),
    categories = C.proto_http
  }
  return r
end

-- Parse media properties.
function parse(qargs)
  local U = require 'quvi/util'
  local p = Dailymotion.fetch_page(qargs, U)

  qargs.thumb_url = p:match('"og:image" content="(.-)"') or ''
  qargs.title = p:match('title="(.-)"') or ''
  qargs.id = p:match("video/([^%?_]+)") or ''

  qargs.streams = Dailymotion.iter_streams(p, U)

  return qargs
end

--
-- Utility functions
--

-- "Normalizes" the embedded URLs.
function Dailymotion.normalize(input_url)
  if input_url:match("/swf/") then
    input_url = input_url:gsub("/swf/", "/")
  elseif input_url:match("/embed/") then
    input_url = input_url:gsub("/embed/", "/")
  end
  return input_url
end

-- Fetches the page contents from the media URL.
function Dailymotion.fetch_page(qargs, U)
  qargs.input_url = Dailymotion.normalize(qargs.input_url)

  local s = qargs.input_url:match('[%?%&]urlback=(.+)')
  if s then
    qargs.input_url = 'http://dailymotion.com' .. U.unescape(s)
  end

  local o = {arbitrary_cookie = 'family_filter=off'}
  return quvi.fetch(qargs.input_url, o)
end

-- Iterates the available streams.
function Dailymotion.iter_streams(page, U)

  local seq = page:match('"sequence",%s+"(.-)"')
                or error('no match: sequence')
  seq = U.unescape(seq)

  local urls = {}
  for q,u in seq:gmatch('"(%w%w)URL":"(.-)"') do
    table.insert(urls, {quality=q, url=Dailymotion.cleanup(U, u)})
  end

  -- Each media page should have at least have this, even if other
  -- stream qualities are not available.
  if #urls ==0 then
    local u = seq:match('"video_url":"(.-)"')
                or error('no match: media stream URL')
    table.insert(urls, {url=Dailymotion.cleanup(U, u)})
  end

  local S = require 'quvi/stream'
  local r = {}

  for _,v in pairs(urls) do
    local c,w,h,cn = v.url:match('(%w+)%-(%d+)x(%d+).-%.(%w+)')

    if c then
      local t = S.stream_new(v.url)

      t.video.encoding = string.lower(c or '')
      t.video.height = tonumber(h)
      t.video.width = tonumber(w)
      t.container = cn or ''

      -- Must come after we have the video resolution, as the to_fmt_id
      -- function uses the height property.
      t.fmt_id = Dailymotion.to_fmt_id(t, v.quality)

      table.insert(r, t)
    end
  end

  if #r >1 then
    Dailymotion.ch_best(S, r)
  end

  return r
end

-- Sanitizes the URL.
function Dailymotion.cleanup(U, u)
  u = U.unescape(u)
  u = U.slash_unescape(u)
  u = u:gsub('cell=secure%-vod&', '') -- http://is.gd/BzYPZJ
  return u
end

-- Picks the stream with the highest video height property
-- as the best in quality.
function Dailymotion.ch_best(S, t)
  local r = t[1] -- Make the first one the 'best' by default.
  r.flags.best = true
  for _,v in pairs(t) do
    if v.video.height > r.video.height then
      r = S.swap_best(r, v)
    end
  end
end

-- Returns a general purpose "format ID" for a stream.
function Dailymotion.to_fmt_id(t, q)
  return string.format("%s_%s_%s_%sp",
    (q) and q or 'sd', t.container, t.video.encoding, t.video.height)
end

-- vim: set ts=2 sw=2 tw=72 expandtab:
