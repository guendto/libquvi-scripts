-- libquvi-scripts
-- Copyright (C) 2013  Toni Gundogdu <legatvs@gmail.com>
-- Copyright (C) 2012  Raphaël Droz <raphael.droz+floss@gmail.com>
-- Copyright (C) 2016  Mike Frysinger <vapier@gentoo.org>
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

local TheScene = {} -- Utility functions unique to this script.

-- Identify the script.
function ident(qargs)
  return {
    can_parse_url = TheScene.can_parse_url(qargs),
    domains = table.concat({'thescene.com'}, ',')
  }
end

-- Parse media properties.
function parse(qargs)
  local C = require 'quvi/const'
  local o = { [C.qoo_fetch_from_charset] = 'utf-8' }
  local p = quvi.http.fetch(qargs.input_url, o).data

  qargs.id = qargs.input_url:match('/watch/(.*)') or ''

  qargs.title = p:match('<title>(.-)</title>') or ''

  qargs.thumb_url = p:match('<link itemprop=.thumbnailURL. src=[\'"]([^\']*)[\'"]>') or ''

  qargs.streams = TheScene.iter_streams(p)

  return qargs
end

--
-- Utility functions.
--

function TheScene.can_parse_url(qargs)
  local U = require 'socket.url'
  local t = U.parse(qargs.input_url)
  local p = '^/watch/'
  if t and t.scheme and t.scheme:lower():match('^https?$')
       and t.host   and t.host:lower():match('^thescene%.com$')
       and t.path   and t.path:lower():match(p)
  then
    return true
  else
    return false
  end
end

function TheScene.iter_streams(p)
  -- Note: This is usually an mp4, and it can be changed to a webm.
  local v = p:match('<link href=[\'"]([^\'"]*)[\'"] itemprop=.contentUrl.>')
              or error('no match: contenturl')

  local S = require 'quvi/stream'
  local t = S.stream_new(v)

  return {t}
end

-- vim: set ts=2 sw=2 tw=72 expandtab:
