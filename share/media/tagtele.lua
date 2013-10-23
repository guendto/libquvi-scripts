-- libquvi-scripts
-- Copyright (C) 2012,2013  Toni Gundogdu <legatvs@gmail.com>
-- Copyright (C) 2010  Paul Kocialkowski <contact@paulk.fr>
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

local Tagtele = {} -- Utility functions unique to this script

-- Identify the media script.
function ident(qargs)
  return {
    can_parse_url = Tagtele.can_parse_url(qargs),
    domains = table.concat({'tagtele.com'}, ',')
  }
end

-- Parse media URL.
function parse(self)
    self.host_id = "tagtele"

    local p = quvi.fetch(self.page_url)

    self.title = p:match("<title>TagTélé%s+-%s+(.-)</title>")
                  or error("no match: media title")

    self.id = self.page_url:match('/voir/(%d+)')
                or error("no match: media ID")

    local pl_url = "http://www.tagtele.com/videos/playlist/"..self.id.."/"
    local pl = quvi.fetch(pl_url, {fetch_type='playlist'})

    self.url = {pl:match("<location>(.-)</")
                  or error("no match: media URL")}

    return self
end

--
-- Utility functions.
--

function Tagtele.can_parse_url(qargs)
  local U = require 'socket.url'
  local t = U.parse(qargs.input_url)
  if t and t.scheme and t.scheme:lower():match('^https?$')
       and t.host   and t.host:lower():match('^www%.tagtele%.com$')
       and t.path   and t.path:lower():match('^/videos/voir/%d+/$')
  then
    return true
  else
    return false
  end
end

-- vim: set ts=4 sw=4 tw=72 expandtab:
