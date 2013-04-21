-- libquvi-scripts
-- Copyright (C) 2011,2013  Toni Gundogdu <legatvs@gmail.com>
-- Copyright (C) 2010 quvi project
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

local FunnyOrDie = {} -- Utility functions unique to this script

-- Identify the media script.
function ident(qargs)
  return {
    can_parse_url = FunnyOrDie.can_parse_url(qargs),
    domains = table.concat({'funnyordie.com'}, ',')
  }
end

-- Parse media properties.
function parse(qargs)
  local p = quvi.http.fetch(qargs.input_url).data

  qargs.thumb_url = p:match('"og:image" content="(.-)"') or ''
  qargs.title = p:match('"og:title" content="(.-)">') or ''
  qargs.id = p:match('key:%s+"(.-)"') or ''

  qargs.streams = FunnyOrDie.iter_streams(p)

  return qargs
end

--
-- Utility functions
--

function FunnyOrDie.can_parse_url(qargs)
  local U = require 'socket.url'
  local t = U.parse(qargs.input_url)
  if t and t.scheme and t.scheme:lower():match('^http$')
       and t.host   and t.host:lower():match('funnyordie%.com$')
       and t.path   and t.path:lower():match('^/videos/%w+')
  then
    return true
  else
    return false
  end
end

function FunnyOrDie.iter_streams(p)
  local t = {}
  for u in p:gmatch('source src="(.-)"') do table.insert(t,u) end
  -- There should be at least two stream URLs at this point.
  -- first: the (playlist) URL for the segmented videos (unusable to us)
  --   ...: the media stream URLs
  if #t <2 then error('no match: media stream URL') end
  table.remove(t,1) -- Remove the first stream URL.

  local S = require 'quvi/stream'
  local r = {}

  -- nostd is a dictionary used by this script only. libquvi ignores it.
  for _,u in pairs(t) do
    local q,c = u:match('/(%w+)%.(%w+)$')
    local s = S.stream_new(u)
    s.nostd = {quality=q}
    s.container = c
    s.id = FunnyOrDie.to_id(s)
    table.insert(r,s)
  end

  if #r >1 then
    FunnyOrDie.ch_best(r)
  end

  return r
end

function FunnyOrDie.ch_best(t)
  t[1].flags.best = true
end

function FunnyOrDie.to_id(t)
  return string.format("%s_%s", t.container, t.nostd.quality)
end

-- vim: set ts=2 sw=2 tw=72 expandtab:
