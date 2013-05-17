-- libquvi-scripts
-- Copyright (C) 2012,2013  Toni Gundogdu <legatvs@gmail.com>
-- Copyright (C) 2011  Bastien Nocera <hadess@hadess.net>
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

local Ted = {} -- Utility functions unique to this script

-- Identify the media script.
function ident(qargs)
  return {
    can_parse_url = Ted.can_parse_url(qargs),
    domains = table.concat({'ted.com'}, ',')
  }
end

-- Query available formats.
function query_formats(self)
    self.formats  = "default"
    Ted.is_external(self, quvi.fetch(self.page_url))
    return self
end

-- Parse video URL.
function parse(self)
    self.host_id = "ted"

    local p = quvi.fetch(self.page_url)

    if Ted.is_external(self, p) then return self end

    self.id = p:match('ti:"(%d+)"') or error("no match: media ID")

    self.title = p:match('<title>(.-)%s+|') or error("no match: media title")

    self.thumbnail_url = p:match('"og:image" content="(.-)"') or ''

    return self
end

--
-- Utility functions
--

function Ted.can_parse_url(qargs)
  local U = require 'socket.url'
  local t = U.parse(qargs.input_url)
  if t and t.scheme and t.scheme:lower():match('^http$')
       and t.host   and t.host:lower():match('^www.ted%.com$')
       and t.path   and t.path:lower():match('^/talks/.+$')
  then
    return true
  else
    return false
  end
end

function Ted.is_external(self, p)
    self.url = {p:match('(http://download.-)"') or ''}
    if #self.url[1] ==0 then  -- Try the first iframe
        self.redirect_url = p:match('<iframe src="(.-)"') or ''
        if #self.redirect_url >0 then
            return true
        else
          error('no match: media stream URL')
        end
    end
    return false
end

-- vim: set ts=4 sw=4 tw=72 expandtab:
