
-- libquvi-scripts
-- Copyright (C) 2011  Bastien Nocera <hadess@hadess.net>
--
-- This file is part of libquvi-scripts <http://quvi.sourceforge.net/>.
--
-- This library is free software; you can redistribute it and/or
-- modify it under the terms of the GNU Lesser General Public
-- License as published by the Free Software Foundation; either
-- version 2.1 of the License, or (at your option) any later version.
--
-- This library is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
-- Lesser General Public License for more details.
--
-- You should have received a copy of the GNU Lesser General Public
-- License along with this library; if not, write to the Free Software
-- Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
-- 02110-1301  USA
--
-- For Soundcloud.toUtf8():
-- Copyright 2004 by Rici Lake. Permission is granted to use this code under
-- the same terms and conditions as found in the Lua copyright notice at
-- http://www.lua.org/license.html.

local Soundcloud = {} -- Utility functions unique to this script

-- Identify the script.
function ident(self)
    package.path = self.script_dir .. '/?.lua'
    local C      = require 'quvi/const'
    local r      = {}
    r.domain     = "soundcloud%.com"
    r.formats    = "default"
    r.categories = C.proto_http
    local U      = require 'quvi/util'
    r.handles    = U.handles(self.page_url,
                    {r.domain}, {"/.+/.+$", "/player.swf"})
    return r
end

-- Query available formats.
function query_formats(self)
    self.formats = 'default'
    return self
end

-- Parse media URL.
function parse(self)
    self.host_id  = "soundcloud"

    Soundcloud.normalize(self)

    local page = quvi.fetch(self.page_url)

    local _,_,s = page:find("window%.SC%.bufferTracks%.push(%(.-%);)")
    local metadata = s or error("no match: metadata")

    local _,_,s = metadata:find('"uid":"(%w-)"')
    self.id = s or error("no match: media id")

    local _,_,s = metadata:find('"title":"(.-)"')
    local title  = s or error("no match: media title")
    -- Unescape the Unicode strings if any
    -- the HTML will be unescaped by quvi itself
    self.title = string.gsub(title, "\\u(%x+)",
        function (h)
            return Soundcloud.toUtf8(tonumber(h, 16))
        end)

    local _,_,s = page:find('content="([:/%w%?%.-]-)" property="og:image"')
    self.thumbnail_url = s or ""

    local _,_,s = metadata:find('"duration":(%d-),')
    self.duration = tonumber(s) or 0

    local _,_,s = metadata:find('"streamUrl":"(.-)"')
    self.url  = { s }  or error("no match: stream URL")

    return self
end

--
-- Utility functions
--

function Soundcloud.normalize(self) -- "Normalize" an embedded URL
    local url = self.page_url:match('swf%?url=(.-)$')
    if not url then return end

    local U = require 'quvi/util'
    local oe_url = string.format(
        'http://soundcloud.com/oembed?url=%s&format=json', U.unescape(url))

    local s = quvi.fetch(oe_url):match('href=\\"(.-)\\"')
    self.page_url = s or error('no match: page url')
end

-- Adapted from http://luaparse.luaforge.net/libquery.lua.html
--
-- Convert an integer to a UTF-8 sequence, without checking for
-- invalid codes.
-- This originally had calls to floor scattered about but it is
-- not necessary: string.char does a "C" conversion from float to int,
-- which is a truncate towards zero operation; i must be non-negative,
-- so that is the same as floor.
function Soundcloud.toUtf8(i)
  if i <= 127 then return string.char(i)
   elseif i <= tonumber("7FF", 16) then
    return string.char(i / 64 + 192, math.mod(i, 64) + 128)
   elseif i <= tonumber("FFFF", 16) then
    return string.char(i / 4096 + 224,
                   math.mod(i / 64, 64) + 128,
                   math.mod(i, 64) + 128)
   else
    return string.char(i / 262144 + 240,
                   math.mod(i / 4096, 64) + 128,
                   math.mod(i / 64, 64) + 128,
                   math.mod(i, 64) + 128)
  end
end

-- vim: set ts=4 sw=4 tw=72 expandtab:
