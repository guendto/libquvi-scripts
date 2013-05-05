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

local ClipFish = {} -- Utility functions unique to this script.

-- Identify the media script.
function ident(qargs)
  return {
    can_parse_url = ClipFish.can_parse_url(qargs),
    domains = table.concat({'clipfish.de'}, ',')
  }
end

-- Parse media URL.
function parse(self)
    self.host_id = "clipfish"

    self.id = self.page_url:match("/video/(.-)/")
                or error("no match: media ID")

    local c_url = "http://www.clipfish.de/devxml/videoinfo/"
                    .. self.id

    local c = quvi.fetch(c_url, {fetch_type = 'config'})

    self.title = c:match('<title><!%[CDATA%[(.-)%]')
                  or error("no match: media title")

    self.thumbnail_url = c:match('<imageurl>(.-)</') or ''

    self.url = {c:match("<filename><!%[CDATA%[(.-)%]")
                  or error("no match: media URL")}

    return self
end

--
-- Utility functions
--

function ClipFish.can_parse_url(qargs)
  local U = require 'socket.url'
  local t = U.parse(qargs.input_url)
  if t and t.scheme and t.scheme:lower():match('^http$')
       and t.host   and t.host:lower():match('clipfish%.de$')
       and t.path   and t.path:lower():match('/video/%d+/.-/$')
  then
    return true
  else
    return false
  end
end

-- vim: set ts=4 sw=4 tw=72 expandtab:
