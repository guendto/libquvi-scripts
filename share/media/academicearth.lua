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

--
-- NOTE: aearth hosts the media at youtube, return 'goto_url'
--

local AcademicEarth = {} -- Utility functions specific to this script

-- Identify the media script.
function ident(qargs)
  return {
    can_parse_url = AcademicEarth.can_parse_url(qargs),
    domains = table.concat({'academicearth.org'}, ',')
  }
end

-- Parse media properties.
function parse(qargs)
  return AcademicEarth.to_media_url(qargs)
end

--
-- Utility functions
--

function AcademicEarth.can_parse_url(qargs)
  local U = require 'socket.url'
  local t = U.parse(qargs.input_url)
  if t and t.scheme and t.scheme:lower():match('^http$')
       and t.host   and t.host:lower():match('academicearth%.org$')
       and t.path   and t.path:lower():match('^/lectures/')
  then
    return true
  else
    return false
  end
end

function AcademicEarth.to_media_url(qargs)
  local p = quvi.http.fetch(qargs.input_url).data
  qargs.goto_url = p:match('"(http://www%.youtube%.com/watch.-)"')
                      or error('no match: unrecognized media source')
  return qargs
end

-- vim: set ts=2 sw=2 tw=72 expandtab:
