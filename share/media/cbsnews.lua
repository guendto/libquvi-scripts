-- libquvi-scripts
-- Copyright (C) 2010-2013  Toni Gundogdu <legatvs@gmail.com>
--
-- This file is part of libquvi-scripts <http://quvi.sourceforge.net/>.
--
-- This program is free software: you can redistribute it and/or
-- modify it under the terms of the GNU Affero General Public
-- License as published by the Free Software Foundation, either
-- version 3 of the License, or (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU Affero General Public License for more details.
--
-- You should have received a copy of the GNU Affero General
-- Public License along with this program.  If not, see
-- <http://www.gnu.org/licenses/>.
--

local CBSNews = {} -- Utility functions unique to this script

-- Identify the script.
function ident(qargs)
  return {
    can_parse_url = CBSNews.can_parse_url(qargs),
    domains = table.concat({'cbsnews.com'}, ',')
  }
end

-- Parse media properties.
function parse(qargs)
  local c = CBSNews.get_data(qargs)

  local L = require 'quvi/lxph'
  local U = require 'quvi/util'
  local P = require 'lxp.lom'

  local x = P.parse(c)

  local v = CBSNews.parse_optional(qargs, x, U, L)

  qargs.streams = CBSNews.iter_streams(U, L, v)

  return qargs
end

--
-- Utility functions
--

function CBSNews.can_parse_url(qargs)
  local U = require 'socket.url'
  local t = U.parse(qargs.input_url)
  if t and t.scheme and t.scheme:lower():match('^http$')
       and t.host   and t.host:lower():match('cbsnews%.com$')
       and t.path   and t.path:lower():match('^/video/watch/')
       and t.query  and t.query:lower():match('^id=%w+$')
  then
    return true
  else
    return false
  end
end

-- Queries the video data from the server.
function CBSNews.get_data(qargs)
  local p = quvi.http.fetch(qargs.input_url).data

  -- Make mandatory for the reason we need it to fetch the config.
  qargs.id = qargs.input_url:match('id=(%d+)') or error('no match: media ID')

  local s = "http://api.cnet.com/restApi/v1.0/videoSearch?videoIds=%s"
              .. "&iod=videoMedia"

  return quvi.http.fetch(string.format(s, qargs.id)).data
end

-- Parse optional properties, e.g. title.
function CBSNews.parse_optional(qargs, x, U, L)
  local v = L.find_first_tag(L.find_first_tag(x, 'Videos'), 'Video')

  qargs.title = U.trim(L.find_first_tag(v, 'Title')[1]) or ''

  local t = L.find_first_tag(v, 'ThumbnailImage')
  qargs.thumb_url = U.trim(L.find_first_tag(t, 'ImageURL')[1]) or ''

  return v
end

-- Iterates the available streams.
function CBSNews.iter_streams(U, L, v)
  local m = L.find_first_tag(v, 'VideoMedias')
  local S = require 'quvi/stream'
  local r = {}

  for i=1, #m do
    if m[i].tag == 'VideoMedia' then
      local u = U.trim(L.find_first_tag(m[i], 'DeliveryUrl')[1])
      local t = S.stream_new(u)
      t.video.bitrate_kbit_s = tonumber(L.find_first_tag(m[i], 'BitRate')[1])
      t.video.height =  tonumber(L.find_first_tag(m[i], 'Height')[1])
      t.video.width = tonumber(L.find_first_tag(m[i], 'Width')[1])
      t.video.encoding = ''
      t.container = u:match('%.(%w+)$') or ''
      t.id = CBSNews.to_id(t)
      table.insert(r, t)
    end
  end

  if #r >1 then
    CBSNews.ch_best(S, r) -- Pick a stream that of the 'best' quality.
  end

  return r
end

-- Return an ID for a stream.
function CBSNews.to_id(t)
  return string.format("%s_%dk_%dp", t.container,
                                     t.video.bitrate_kbit_s,
                                     t.video.height)
end

-- Picks the stream with the highest video height property.
function CBSNews.ch_best(S, t)
  local r = t[1] -- Set the first stream as the default 'best'.
  r.flags.best = true
  for _,v in pairs(t) do
    if v.video.height > r.video.height then
      r = S.swap_best(r, v)
    end
  end
end

-- vim: set ts=2 sw=2 tw=72 expandtab:
