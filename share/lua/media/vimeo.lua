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

--
-- NOTE: Vimeo is picky about the user-agent string.
--

local Vimeo = {} -- Utility functions unique to this script.

-- Identify the media script.
function ident(qargs)
  local A = require 'quvi/accepts'
  local C = require 'quvi/const'
  local r = {
    accepts = A.accepts(qargs.input_url, {"vimeo%.com"}, {"/%d+$"}),
    categories = C.qmspc_http
  }
  return r
end

-- Parse media stream URL.
function parse(qargs)
  Vimeo.normalize(qargs)

  local p = quvi.fetch(qargs.input_url)
  local U = require 'quvi/util'

  qargs.id = qargs.input_url:match('/(%d+)$') or error('no match: media ID')
  qargs.duration_ms =(tonumber(p:match('"duration_ms":(%d+)')) or 0) * 1000
  qargs.thumb_url = U.slash_unescape(p:match('"thumbnail":"(.-)"') or '')

  local s = p:match('"title":(.-),') or ''
  qargs.title = U.slash_unescape(s):gsub('^"',''):gsub('"$','')

  qargs.streams = Vimeo.iter_streams(qargs, p)

  return qargs
end

--
-- Utility functions
--

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
      t.fmt_id = Vimeo.to_fmt_id(t, q)
      table.insert(r, t)
    end
  end

  if #r >1 then
    Vimeo.ch_best(r)
  end

  return r
end

function Vimeo.normalize(qargs)
  local u = qargs.input_url:gsub("player.", "") -- player.vimeo.com
  qargs.input_url = u:gsub("/video/", "/")
end

function Vimeo.ch_best(t)
  t[1].flags.best = true -- Should be the 'hd'.
end

function Vimeo.to_fmt_id(t, quality)
  return string.format("%s_%s", quality, t.video.encoding)
end

-- vim: set ts=2 sw=2 tw=72 expandtab:
