-- libquvi-scripts
-- Copyright (C) 2013  Toni Gundogdu <legatvs@gmail.com>
-- Copyright (C) 2011  Lionel Elie Mamane <lionel@mamane.lu>
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

local Metacafe = {} -- Utility functions unique to this script.

-- Identify the media script.
function ident(qargs)
  return {
    can_parse_url = Metacafe.can_parse_url(qargs),
    domains = table.concat({'metacafe.com'}, ',')
  }
end

-- Parse media URL.
function parse(self)
    self.host_id = "metacafe"

    if Metacafe.redirectp(self) then
        return self
    end

    local U = require 'quvi/util'
    local p = Metacafe.fetch_page(self, U)

    local v = p:match('name="flashvars" value="(.-)"')
                or error('no match: flashvars')

    v = U.slash_unescape(U.unescape(v))

    self.thumbnail_url = p:match('rel="image_src" href="(.-)"') or ''

    self.title = v:match('title=(.-)&') or error('no match: media title')

    self.id = v:match('itemID=(%d+)') or error('no match: media ID')

    local u = v:match('"mediaURL":"(.-)"')
                or error('no match: media stream URL')

    local k = v:match('"key":"__gda__","value":"(.-)"')
                or error('no match: key')

    self.url = {string.format("%s?__gda__=%s", u, k)}

    return self
end

--
-- Utility functions
--

function Metacafe.can_parse_url(qargs)
  local U = require 'socket.url'
  local t = U.parse(qargs.input_url)
  if t and t.scheme and t.scheme:lower():match('^http$')
       and t.host   and t.host:lower():match('metacafe%.com$')
       and t.path   and (t.path:lower():match('^/watch/%d+/')
                          or t.path:lower():match('^/watch/yt-[^/]+/'))
  then
    return true
  else
    return false
  end
end

function Metacafe.redirectp(self)
    local s = self.page_url:match('/watch/yt%-([^/]+)/')
    if s then -- Hand over to youtube.lua
        self.redirect_url = 'http://youtube.com/watch?v=' .. s
        return true
    end
    return false
end

function Metacafe.fetch_page(self, U)
    self.page_url = Metacafe.normalize(self.page_url)

    return quvi.fetch(self.page_url)
end

function Metacafe.normalize(page_url) -- "Normalize" embedded URLs
    return page_url
end

-- vim: set ts=4 sw=4 tw=72 expandtab:
