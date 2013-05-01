-- libquvi-scripts
-- Copyright (C) 2011,2013  Toni Gundogdu <legatvs@gmail.com>
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

local Guardian = {} -- Utility functions unique to this script

-- Identify the media script.
function ident(qargs)
  return {
    can_parse_url = Guardian.can_parse_url(qargs),
    domains = table.concat({'guardian.co.uk'}, ',')
  }
end

-- Query available formats.
function query_formats(self)
    self.formats = 'default'
    return self
end

-- Parse media URL.
function parse(self)
    self.host_id = "guardian"

    local p = quvi.fetch(self.page_url)

    self.title = p:match('"og:title" content="(.-)"')
                    or error('no match: media title')

    self.id = p:match('containerID%s+=%s+["\'](.-)["\']')
                  or p:match('audioID%s+=%s+["\'](.-)["\']')
                      or ''

    self.id = self.id:match('(%d+)') or error('no match: media ID')

    self.duration = tonumber(p:match('duration%:%s+"?(%d+)"?') or 0) * 1000

    self.thumbnail_url = p:match('"thumbnail" content="(.-)"')
                            or p:match('"og:image" content="(.-)"') or ''

    self.url = {p:match('file:%s+"(.-)"')
                  or error('no match: media stream URL')}

    return self
end

--
-- Utility functions
--

function Guardian.can_parse_url(qargs)
  local U = require 'socket.url'
  local t = U.parse(qargs.input_url)
  if t and t.scheme and t.scheme:lower():match('^https?$')
       and t.host   and t.host:lower():match('guardian%.co%.uk$')
       and t.path   and (t.path:lower():match('/video/')
                         or t.path:lower():match('/audio/'))
  then
    return true
  else
    return false
  end
end

-- vim: set ts=4 sw=4 tw=72 expandtab:
