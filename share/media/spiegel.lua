-- libquvi-scripts
-- Copyright (C) 2010-2011,2013  Toni Gundogdu <legatvs@gmail.com>
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
-- NOTE: Some streams (e.g. 3gp) do not appear to be available (404) even
--       if they are listed in the config XML.
--

local Spiegel = {} -- Utility functions unique to this script

-- Identify the media script.
function ident(qargs)
  return {
    can_parse_url = Spiegel.can_parse_url(qargs),
    domains = table.concat({'spiegel.de'}, ',')
  }
end

-- Query available formats.
function query_formats(self)
    Spiegel.get_media_id(self)

    local config  = Spiegel.get_config(self)
    local formats = Spiegel.iter_formats(config)

    local t = {}
    for _,v in pairs(formats) do
        table.insert(t, Spiegel.to_s(v))
    end

    table.sort(t)
    self.formats = table.concat(t, "¦")

    return self
end

-- Parse media URL.
function parse(self)
    self.host_id = "spiegel"

    local p = quvi.fetch(self.page_url)

    self.title = p:match('"spVideoTitle">(.-)<')
                    or error('no match: media title')

    self.thumbnail_url = p:match('"og:image" content="(.-)"') or ''

    Spiegel.get_media_id(self)

    local config  = Spiegel.get_config(self)
    local formats = Spiegel.iter_formats(config)

    local U       = require 'quvi/util'
    local format  = U.choose_format(self, formats,
                                    Spiegel.choose_best,
                                    Spiegel.choose_default,
                                    Spiegel.to_s)
                        or error("unable to choose format")
    self.duration = (format.duration or 0) * 1000 -- to msec
    self.url      = {format.url or error("no match: media url")}

    return self
end

--
-- Utility functions
--

function Spiegel.can_parse_url(qargs)
  local U = require 'socket.url'
  local t = U.parse(qargs.input_url)
  if t and t.scheme and t.scheme:lower():match('^http$')
       and t.host   and t.host:lower():match('spiegel%.de$')
       and t.path   and t.path:lower():match('^/video/.-%d+%.html$')
  then
    return true
  else
    return false
  end
end

function Spiegel.get_media_id(self)
    self.id = self.page_url:match("/video/.-video%-(.-)%.")
                or error ("no match: media id")
end

function Spiegel.get_config(self)
    local fmt_s      = "http://video.spiegel.de/flash/%s.xml"
    local config_url = string.format(fmt_s, self.id)
    return quvi.fetch(config_url, {fetch_type = 'config'})
end

function Spiegel.iter_formats(config)
    local p = '<filename>(.-)<'
           .. '.-<codec>(.-)<'
           .. '.-<totalbitrate>(%d+)'
           .. '.-<width>(%d+)'
           .. '.-<height>(%d+)'
           .. '.-<duration>(%d+)'
    local t = {}
    for fn,c,b,w,h,d in config:gmatch(p) do
        local cn = fn:match('%.(%w+)$') or error('no match: container')
        local u = 'http://video.spiegel.de/flash/' .. fn
--        print(u,c,b,w,h,cn,d)
        table.insert(t, {codec=string.lower(c), url=u,
                         width=tonumber(w),     height=tonumber(h),
                         bitrate=tonumber(b),   duration=tonumber(d),
                         container=cn})
    end
    return t
end

function Spiegel.choose_best(formats) -- Highest quality available
    local r = {width=0, height=0, bitrate=0, url=nil}
    local U = require 'quvi/util'
    for _,v in pairs(formats) do
        if U.is_higher_quality(v,r) then
            r = v
        end
    end
    return r
end

function Spiegel.choose_default(formats)
    return formats[1]
end

function Spiegel.to_s(t)
    return string.format('%s_%s_%sk_%sp',
        t.container, t.codec, t.bitrate, t.height)
end

-- vim: set ts=4 sw=4 tw=72 expandtab:
