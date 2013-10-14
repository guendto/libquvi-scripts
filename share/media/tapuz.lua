-- libquvi-scripts
-- Copyright (C) 2013  Toni Gundogdu <legatvs@gmail.com>
-- Copyright (C) 2012  Tzafrir Cohen <tzafrir@cohens.org.il>
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

local Tapuz = {} -- Utility functions unique to this script

-- Identify the media script.
function ident(qargs)
  return {
    can_parse_url = Tapuz.can_parse_url(qargs),
    domains = table.concat({'flix.tapuz.co.il'}, ',')
  }
end

-- Query available formats.
function query_formats(self)
    self.formats = 'default'
    return self
end

-- Parse media URL.
function parse(self)
    self.host_id = 'tapuz-flix'

    self.id = self.page_url:match('/v/watch%-(%d+)%-.*%.html')
    if not self.id then
        self.id = self.page_url:match('/showVideo%.asp%?m=(%d+)')
                    or error("no match: media ID")
    end

    local xml_url_base = 'v/Handlers/XmlForPlayer.ashx' -- Variable?
    local mako = 0 -- Does it matter?
    local playerOptions = '0|1|grey|large|0' -- Does it matter? Format?

    local p = quvi.fetch(self.page_url)
    self.title = p:match('<meta name="item%-title" content="([^"]*)" />')

    local s_fmt =
      'http://flix.tapuz.co.il/%s?mediaid=%d&autoplay=0&mako=%d'
      .. '&playerOptions=%s'

    local xml_url =
      string.format(s_fmt, xml_url_base, self.id, mako, playerOptions)

    local xml_page = quvi.fetch(xml_url)
    self.url = { xml_page:match('<videoUrl>.*(http://.*%.flv).*</videoUrl>') }

    return self
end

--
-- Utility functions.
--

function Tapuz.can_parse_url(qargs)
  local U = require 'socket.url'
  local t = U.parse(qargs.input_url)
  if t and t.scheme and t.scheme:lower():match('^http$')
       and t.host   and t.host:lower():match('flix%.tapuz%.co%.il$')
       and t.path   and (t.path:lower():match('^/v/watch%-.-%.html$')
                          or t.path:lower():match('/showVideo%.asp%?m=%d+'))
  then
    return true
  else
    return false
  end
end

-- vim: set ts=4 sw=4 tw=72 expandtab:
