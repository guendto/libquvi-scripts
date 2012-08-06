-- libquvi-scripts
-- Copyright (C) 2012  Toni Gundogdu <legatvs@gmail.com>
-- Copyright (C) 2011  Bastien Nocera <hadess@hadess.net>
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

local Soundcloud = {} -- Utility functions unique to this script

-- Identify the media script.
function ident(qargs)
  local A = require 'quvi/accepts'
  local C = require 'quvi/const'
  local p = {"/.+/.+$", "/player.swf"} -- paths
  local r = {
    accepts = A.accepts(qargs.input_url, {"soundcloud%.com"}, p),
    categories = C.qmspc_http
  }
  return r
end

-- Parse media properties.
function parse(qargs)
  Soundcloud.normalize(qargs)

  local p = quvi.fetch(qargs.input_url)

  qargs.thumb_url = p:match('.+content="(.-)"%s+property="og:image"') or ''
  qargs.title = p:match('.+content="(.-)"%s+property="og:title"') or ''

  local m = p:match("window%.SC%.bufferTracks%.push(%(.-%);)")
              or error("no match: metadata")

  qargs.duration_ms = tonumber(m:match('"duration":(%d-),')) or 0
  qargs.id = m:match('"uid":"(%w-)"') or ''

  qargs.streams = Soundcloud.iter_streams(m);

  return qargs
end

--
-- Utility functions
--

function Soundcloud.normalize(qargs) -- "Normalize" an embedded URL
  local url = qargs.input_url:match('swf%?url=(.-)$')
  if not url then return end

  local U = require 'quvi/util'
  local u = string.format('http://soundcloud.com/oembed?url=%s&format=json',
                            U.unescape(url))

  qargs.input_url = quvi.fetch(u):match('href=\\"(.-)\\"')
                      or error('no match: media URL')
end

function Soundcloud.iter_streams(p)
  local u = p:match('"streamUrl":"(.-)"')
              or error("no match: media stream URL")
  local S = require 'quvi/stream'
  return {S.stream_new(u)}
end

-- vim: set ts=2 sw=2 tw=72 expandtab:
