-- libquvi-scripts
-- Copyright (C) 2013  Toni Gundogdu <legatvs@gmail.com>
-- Copyright (C) 2012  Guido Leisker <guido@guido-leisker.de>
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

local MySpass = {} -- Utility functions unique to this script

-- Identify the media script.
function ident(qargs)
  return {
    can_parse_url = MySpass.can_parse_url(qargs),
    domains = table.concat({'myspass.de'}, ',')
  }
end

-- Query available formats.
function query_formats(self)
    self.formats = 'default'
    return self
end

-- Parse media URL.
function parse(self)
  self.host_id = "myspass"

  self.id = self.page_url:match("(%d+)/?$")
      or error("no match: media ID")

  local format  = MySpass.getMetadataValue(self, 'format')
  local title   = MySpass.getMetadataValue(self, 'title')
  local season  = MySpass.getMetadataValue(self, 'season')
  local episode = MySpass.getMetadataValue(self, 'episode')
  self.thumbnail_url = MySpass.getMetadataValue(self, 'imagePreview') or ''

  self.title = string.format("%s %03d %03d %s", format, season,
                             episode, title)

  self.url = {MySpass.getMetadataValue(self, 'url_flv')}

  return self
end

--
-- Utility functions
--

function MySpass.can_parse_url(qargs)
  local U = require 'socket.url'
  local t = U.parse(qargs.input_url)
  if t and t.scheme and t.scheme:lower():match('^http$')
       and t.host   and t.host:lower():match('myspass%.de$')
       -- Expect all URLs ending with digits to be videos.
       and t.path   and t.path:lower():match('^/myspass/.-/%d+/?$')
  then
    return true
  else
    return false
  end
end

function MySpass.getMetadataValue(self, key)
  if self.metadata == nil then
    self.metadata =  quvi.fetch(
      'http://www.myspass.de/myspass/'
          .. 'includes/apps/video/getvideometadataxml.php?id='
          .. self.id ) or error("cannot fetch meta data xml file")
  end
  local p = string.format("<%s>(.-)</%s>", key, key)
  local temp = self.metadata:match(p) or error("meta data: no match: " .. key)
  local value = temp:match('<!%[CDATA%[(.+)]]>') or temp
  return value
end

-- vim: set ts=2 sw=2 tw=72 expandtab:

