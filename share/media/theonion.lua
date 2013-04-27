-- libquvi-scripts
-- Copyright (C) 2012-2013  Toni Gundogdu <legatvs@gmail.com>
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

local TheOnion = {} -- Utility functions unique to this script.

-- Identify the media script.
function ident(qargs)
  return {
    can_parse_url = TheOnion.can_parse_url(qargs),
    domains = table.concat({'theonion.com'}, ',')
  }
end

-- Query available formats.
function query_formats(self)
    self.formats = 'default'
    return self
end

-- Parse media URL.
function parse(self)
    self.host_id = "theonion"

    self.id = self.page_url:match(',(%d+)/') or error('no match: media ID')

    local u = string.format('http://theonion.com/videos/embed/%s.json',
                              self.id)

    local c = quvi.fetch(u, {fetch_type='config'})

    self.title = c:match('"title":%s+"(.-)"')
                  or error('no match: media title')

    self.thumbnail_url = c:match('"thumbnail": %["(.-)"%]') or ''

    self.url = {c:match('"video_url":%s+"(.-)"')
                  or error('no match: media stream URL')}

    return self
end

--
-- Utility functions
--

function TheOnion.can_parse_url(qargs)
  local U = require 'socket.url'
  local t = U.parse(qargs.input_url)
  if t and t.scheme and t.scheme:lower():match('^http$')
       and t.host   and t.host:lower():match('theonion%.com$')
       and t.path   and t.path:lower():match('^/video/.-,%d+/')
  then
    return true
  else
    return false
  end
end

-- vim: set ts=4 sw=4 tw=72 expandtab:
