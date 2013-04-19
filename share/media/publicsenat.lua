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

-- Query available formats.
function query_formats(self)
    self.formats = 'default'
    return self
end

-- Parse media URL.
function parse(self)
    self.host_id = "publicsenat"

    local p = quvi.fetch(self.page_url)

    self.title = p:match('<title>(.-)%s+%|') or error("no match: media title")

    self.id = self.page_url:match(".-idE=(%d+)$")
              or self.page_url:match(".-/(%d+)$")
              or error("no match: media ID")

    local t = p:match('id="imgEmissionSelect" value="(.-)"') or ''
    if #t >0 then
      self.thumbnail_url = 'http://publicsenat.fr' .. t
    end

    local u = "http://videos.publicsenat.fr/vodiFrame.php?idE=" ..self.id
    local c = quvi.fetch(u, {fetch_type='config'})

    self.url = {c:match('id="flvEmissionSelect" value="(.-)"')
                or error("no match: media stream URL")}

    return self
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

-- vim: set ts=4 sw=4 tw=72 expandtab:
