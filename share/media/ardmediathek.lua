-- libquvi-scripts
-- Copyright (C) 2013  Toni Gundogdu <legatvs@gmail.com>
-- Copyright (C) 2013  Thomas Weißschuh <thomas@t-8ch.de>
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

local ArdMediathek = {} -- Utility functions unique to to this script.

-- Identify the media script.
function ident(qargs)
  return {
    can_parse_url = ArdMediathek.can_parse_url(qargs),
    domains = table.concat({'ardmediathek.de'}, ',')
  }
end

function query_formats(self)
    local config = ArdMediathek.get_config(self)
    local formats = ArdMediathek.iter_formats(config)

    local t = {}
    for _,v in pairs(formats) do
        table.insert(t, ArdMediathek.to_s(v))
    end

    table.sort(t)
    self.formats = table.concat(t, "|")

    return self
end

function parse(self)

    local config = ArdMediathek.get_config(self)
    local Util  = require 'quvi/util'

    self.host_id = 'ard'
    self.title = config:match(
                     '<meta property="og:title" content="([^"]*)'
                 ):gsub(
                    '%s*%- %w-$', '' -- remove name of station
                 ):gsub(
                    '%s*%(FSK.*', '' -- remove FSK nonsense
                 )
                 or error('no match: media title')
    self.thumbnail_url = config:match(
                             '<meta property="og:image" content="([^"]*)'
                         ) or ''

    local formats = ArdMediathek.iter_formats(config)
    local format  = Util.choose_format(self,
                                       formats,
                                       ArdMediathek.choose_best,
                                       ArdMediathek.choose_default,
                                       ArdMediathek.to_s)
                    or error('unable to choose format')

    if not format.url then error('no match: media url') end
    self.url = { format.url }

    return self
end

--
-- Utility functions
--

function ArdMediathek.can_parse_url(qargs)
  local U = require 'socket.url'
  local t = U.parse(qargs.input_url)
  if t and t.scheme and t.scheme:lower():match('^http$')
       and t.host   and t.host:lower():match('ardmediathek%.de$')
       and t.query  and t.query:match('^documentId=%d+$')
  then
    return true
  else
    return false
  end
end

function ArdMediathek.test_availability(page)
    -- some videos are only scrapable at certain times
    local fsk_pattern =
        'Der Clip ist deshalb nur von (%d%d?) bis (%d%d?) Uhr verfügbar'
    local from, to = page:match(fsk_pattern)
    if from and to then
        error('video only available from ' ..from.. ':00 to '
              ..to.. ':00 CET')
    end
end

function ArdMediathek.get_config(self)
    local c = quvi.fetch(self.page_url)
    self.id = self.page_url:match('documentId=(%d*)')
              or error('no match: media id')
    if c:match('<title>ARD Mediathek %- Fehlerseite</title>') then
        error('invalid URL, maybe the media is no longer available')
    end

    return c
end

function ArdMediathek.choose_best(t)
    return t[#t] -- return the last from the array
end

function ArdMediathek.choose_default(t)
    return t[1] -- return the first from the array
end

function ArdMediathek.to_s(t)
    return string.format("%s_%s_i%02d%s%s",
              (t.quality) and t.quality or 'sd',
              t.container, t.stream_id,
              (t.encoding) and '_'..t.encoding or '',
              (t.height) and '_'..t.height or '')
end

function ArdMediathek.quality_from(suffix)
    local q = suffix:match('%.web(%w)%.') or suffix:match('%.(%w)%.')
                or suffix:match('[=%.]Web%-(%w)') -- .webs. or Web-S or .s
    if q then
        q = q:lower()
        local t = {s='ld', m='md', l='sd', xl='hd'}
        for k,v in pairs(t) do
            if q == k then return v end
        end
    end
    return q
end

function ArdMediathek.height_from(suffix)
    local h = suffix:match('_%d+x(%d+)[_%.]')
    if h then return h..'p' end
end

function ArdMediathek.container_from(suffix)
    return suffix:match('^(...):') or suffix:match('%.(...)$') or 'mp4'
end

function ArdMediathek.iter_formats(page)
    local r = {}
    local s = 'mediaCollection%.addMediaStream'
                .. '%(0, (%d+), "(.-)", "(.-)", "%w+"%);'

    ArdMediathek.test_availability(page)

    for s_id, prefix, suffix in  page:gmatch(s) do
        local u = prefix .. suffix
        u = u:match('^(.-)?') or u  -- remove querystring
        local t = {
            container = ArdMediathek.container_from(suffix),
            encoding = suffix:match('%.(h264)%.'),
            quality = ArdMediathek.quality_from(suffix),
            height = ArdMediathek.height_from(suffix),
            stream_id = s_id, -- internally (by service) used stream ID
            url = u
        }
        table.insert(r,t)
    end
    if #r == 0 then error('no media urls found') end
    return r
end

-- vim: set ts=4 sw=4 sts=4 tw=72 expandtab:
