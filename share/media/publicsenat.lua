-- libquvi-scripts
-- Copyright (C) 2013  Toni Gundogdu <legatvs@gmail.com>
-- Copyright (C) 2010,2012  Raphaël Droz <raphael.droz+floss@gmail.com>
--
-- This file is part of libquvi-scripts <http://quvi.googlecode.com/>.
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

local PublicSenat = {} -- Utility functions unique to this script.

-- Identify the script.
function ident(qargs)
  return {
    can_parse_url = PublicSenat.can_parse_url(qargs),
    domains = table.concat({'publicsenat.fr'}, ',')
  }
end

-- Parse media properties.
function parse(qargs)
  local p = quvi.http.fetch(qargs.input_url).data

  local t = p:match('id="imgEmissionSelect" value="(.-)"') or ''
  qargs.thumb_url = (#t >0) and ('http://publicsenat.fr'..t) or ''

  qargs.id = qargs.input_url:match("/vod/.-/(%d+)$") or ''
  qargs.title = p:match('<title>(.-)%s+%|') or ''

  qargs.streams = PublicSenat.iter_streams(p)

  return qargs
end

--
-- Utility functions.
--

function PublicSenat.can_parse_url(qargs)
  local U = require 'socket.url'
  local t = U.parse(qargs.input_url)
  if t and t.scheme and t.scheme:lower():match('^http$')
       and t.host   and t.host:lower():match('publicsenat%.fr$')
       and t.path   and t.path:lower():match('^/vod/.-/%d+')
  then
    return true
  else
    return false
  end
end

function PublicSenat.iter_streams(p)
  local u = p:match('id="flvEmissionSelect" value="(.-)"')
              or error('no match: media stream URL')
  local S = require 'quvi/stream'
  return {S.stream_new(u)}
end

-- vim: set ts=2 sw=2 tw=72 expandtab:
