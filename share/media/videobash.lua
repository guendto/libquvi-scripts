-- libquvi-scripts
-- Copyright (C) 2012  Toni Gundogdu <legatvs@gmail.com>
-- Copyright (C) 2011  Thomas Preud'homme <robotux@celest.fr>
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

local Videobash = {} -- Utility functions unique to this script

-- Identify the media script.
function ident(qargs)
  return {
    can_parse_url = Videobash.can_parse_url(qargs),
    domains = table.concat({'videobash.com'}, ',')
  }
end

-- Parse media URL.
function parse(self)
    self.host_id = "videobash"

    local p = quvi.fetch(self.page_url)

    self.title = p:match("<title>(.-)%s+-")
                  or error ("no match: media title")

    self.id = p:match("addFavorite%((%d+)")
                or error ("no match: media ID")

    local s = p:match('file="(.-);') or error("no match: media URL")
    s = s:gsub("[%s+']+", '')

    self.thumbnail_url = p:match('og:image"%s+content="(.-)"') or ''

    local U  = require 'quvi/util'
    self.url = {U.unescape(s)}

    return self
end

--
-- Utility functions.
--

function Videobash.can_parse_url(qargs)
  local U = require 'socket.url'
  local t = U.parse(qargs.input_url)
  if t and t.scheme and t.scheme:lower():match('^https?$')
       and t.host   and t.host:lower():match('^www%.videobash%.com$')
       and t.path   and t.path:lower():match('^/video_show/.-%d+$')
  then
    return true
  else
    return false
  end
end

-- vim: set ts=4 sw=4 tw=72 expandtab:
