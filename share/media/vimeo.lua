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

--
-- NOTE: Vimeo is picky about the user-agent string.
--

local Vimeo = {} -- Utility functions unique to this script.

-- Identify the media script.
function ident(qargs)
  return {
    can_parse_url = Vimeo.can_parse_url(qargs),
    domains = table.concat({'vimeo.com'}, ',')
  }
end

-- Parse media stream URL.
function parse(qargs)
  Vimeo.normalize(qargs)

  local p = quvi.http.fetch(qargs.input_url).data
  local U = require 'quvi/util'

  qargs.id = qargs.input_url:match('/(%d+)$') or error('no match: media ID')
  qargs.duration_ms =(tonumber(p:match('"duration":(%d+)')) or 0) * 1000
  qargs.thumb_url = U.slash_unescape(p:match('"thumbnail":"(.-)"') or '')

  local s = p:match('"title":(.-),') or ''
  qargs.title = U.slash_unescape(s):gsub('^"',''):gsub('"$','')

  qargs.streams = Vimeo.iter_streams(qargs, p)

  return qargs
end

--
-- Utility functions
--

function Vimeo.can_parse_url(qargs)
  Vimeo.normalize(qargs)
  local U = require 'socket.url'
  local t = U.parse(qargs.input_url)
  if t and t.scheme and t.scheme:lower():match('^http$')
       and t.host   and t.host:lower():match('vimeo%.com$')
       and t.path   and t.path:lower():match('^/%d+$')
  then
    return true
  else
    return false
  end
end

function Vimeo.iter_streams(qargs, page)
  local p = page:match('"profiles":{(.-)},') or error('no match: profiles')

  local rs = page:match('"signature":"(.-)"')
              or error('no match: request signature')

  local rt = page:match('"timestamp":(%d+)')
              or error('no match: request timestamp')

  local f = "http://player.vimeo.com/play_redirect?clip_id=%s"
              .. "&sig=%s&time=%s&quality=%s&type=moogaloop_local"

  local S = require 'quvi/stream'
  local r = {}

  for e,a in p:gmatch('"(.-)":{(.-)}') do -- For each profile.
    for q in a:gmatch('"(.-)":%d+') do    -- For each quality in the profile.
      local u = string.format(f, qargs.id, rs, rt, q)
      local t = S.stream_new(u)
      t.video.encoding = string.lower(e or '')
      t.id = Vimeo.to_id(t, q)
      table.insert(r, t)
    end
  end

  if #r >1 then
    Vimeo.ch_best(r)
  end

  return r
end

function Vimeo.normalize(qargs)
  qargs_input_url = qargs.input_url:gsub("player%.", "")
  qargs.input_url = qargs.input_url:gsub("/video/", "/")
end

function Vimeo.ch_best(t)
  t[1].flags.best = true -- Should be the 'hd'.
end

-- Return an ID for a stream.
function Vimeo.to_id(t, quality)
  return string.format("%s_%s", quality, t.video.encoding)
end

-- vim: set ts=2 sw=2 tw=72 expandtab:
