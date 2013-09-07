-- libquvi-scripts
-- Copyright (C) 2013  Toni Gundogdu <legatvs@gmail.com>
-- Copyright (C) 2012  Ross Burton <ross@burtonini.com>
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

local Lego = {} -- Utility functions unique to this script

-- Identify the media script.
function ident(qargs)
  return {
    can_parse_url = Lego.can_parse_url(qargs),
    domains = table.concat({'city.lego.com'}, ',')
  }
end

-- Query available formats.
function query_formats(self)
    self.formats  = "default"
    return self
end

-- Parse video URL.
function parse(self)
    self.host_id = "lego"

    local p = quvi.fetch(self.page_url)

    local d = p:match('FirstVideoData = {(.-)};')
                or error('no match: FirstVideoData')

    self.title = d:match('"Name":"(.-)"')
                  or error('no match: media title')

    self.id = d:match('"LikeObjectGuid":"(.-)"') -- Lack of a better.
                  or error('no match: media ID')

    self.url = {d:match('"VideoFlash":%{"Url":"(.-)"')
                  or error('no match: media stream URL')}

    -- TODO: return self.thumbnail_url

    return self
end

--
-- Utility functions.
--

function Lego.can_parse_url(qargs)
  local U = require 'socket.url'
  local t = U.parse(qargs.input_url)
  if t and t.scheme and t.scheme:lower():match('^http$')
       and t.host   and t.host:lower():match('^city%.lego%.com$')
       and t.path   and t.path:lower():match('/%w+%-%w+/movies/')
  then
    return true
  else
    return false
  end
end
