-- libquvi-scripts
-- Copyright (C) 2011-2013  Toni Gundogdu <legatvs@gmail.com>
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

local Audioboo = {} -- Utility functions unique to this script.

-- Identify the script.
function ident(qargs)
  return {
    can_parse_url = Audioboo.can_parse_url(qargs),
    domains = table.concat({'audioboo.fm'}, ',')
  }
end

-- Parse media URL.
function parse (self)
    self.host_id = "audioboo"

    self.id = self.page_url:match('/boos/(%d+)%-')
                or error('no match: media ID')

    local p = quvi.fetch(self.page_url)

    self.title =
        p:match('.+content=[\'"](.-)[\'"]%s+property=[\'"]og:title[\'"]')
          or error('no match: media title')

    self.thumbnail_url =
        p:match('.+content=[\'"](.-)[\'"]%s+property=[\'"]og:image[\'"]')
          or ''

    self.url = {
        p:match('.+content=[\'"](.-)[\'"]%s+property=[\'"]og:audio[\'"]')
          or error('no match: media stream URL')
    }
    return self
end

--
-- Utility functions
--

function Audioboo.can_parse_url(qargs)
  local U = require 'socket.url'
  local t = U.parse(qargs.input_url)
  if t and t.scheme and t.scheme:lower():match('^https?$')
       and t.host   and t.host:lower():match('audioboo%.fm$')
       and t.path   and t.path:lower():match('^/boos/%d+%-')
  then
    return true
  else
    return false
  end
end

-- vim: set ts=4 sw=4 tw=72 expandtab:
