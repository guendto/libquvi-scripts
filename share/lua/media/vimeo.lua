-- libquvi-scripts
-- Copyright (C) 2010-2012  Toni Gundogdu <legatvs@gmail.com>
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

--
-- NOTE: Vimeo is picky about the user-agent string.
--

local Vimeo = {} -- Utility functions unique to this script.

-- Identify the media script.
function ident(qargs)
  local A = require 'quvi/accepts'
  local C = require 'quvi/const'
  local r = {
    accepts = A.accepts(qargs.input_url, {"vimeo%.com"}, {"/%d+$"}),
    categories = C.proto_http
  }
  return r
end

-- Parse media stream URL.
function parse(qargs)
  Vimeo.normalize(qargs)

  local p = quvi.fetch(qargs.input_url)
  local U = require 'quvi/util'

  qargs.id = qargs.input_url:match('/(%d+)$') or error('no match: media ID')
  qargs.duration_ms =(tonumber(p:match('"duration_ms":(%d+)')) or 0) * 1000
  qargs.thumb_url = U.slash_unescape(p:match('"thumbnail":"(.-)"') or '')

  local s = p:match('"title":(.-),') or ''
  qargs.title = U.slash_unescape(s):gsub('^"',''):gsub('"$','')

  qargs.streams = Vimeo.iter_streams(qargs, p)

  return qargs
end

--
-- Utility functions
--

function Vimeo.normalize(qargs)
  local u = qargs.input_url:gsub("player.", "") -- player.vimeo.com
  qargs.input_url = u:gsub("/video/", "/")
end

function Vimeo.get_config(self)
    self.page_url = Vimeo.normalize(self.page_url)

    self.id = self.page_url:match('vimeo.com/(%d+)')
                or error("no match: media ID")

    local c_url = "http://vimeo.com/" .. self.id
    local c = quvi.fetch(c_url, {fetch_type='config'})

    if c:match('<error>') then
        local s = c:match('<message>(.-)[\n<]')
        error( (not s) and "no match: error message" or s )
    end

    return c
end

function Vimeo.iter_formats(self, config)
    local t = {}
    local qualities = config:match('"qualities":%[(.-)%]')
                        or error('no match: qualities')
    for q in qualities:gmatch('"(.-)"') do
        Vimeo.add_format(self, config, t, q)
    end
    return t
end

function Vimeo.add_format(self, config, t, quality)
    table.insert(t, {quality=quality,
                     url=Vimeo.to_url(self, config, quality)})
end

function Vimeo.choose_best(t) -- First 'hd', then 'sd' and 'mobile' last.
    for _,v in pairs(t) do
        local f = Vimeo.to_s(v)
        for _,q in pairs({'hd','sd','mobile'}) do
            if f == q then return v end
        end
    end
    return Vimeo.choose_default(t)
end

function Vimeo.choose_default(t)
  for _,v in pairs(t) do
      if Vimeo.to_s(v) == 'sd' then return v end -- Default to 'sd'.
  end
  return t[1] -- Or whatever is the first.
end

function Vimeo.to_url(self, config, quality)
    local sign = config:match('"signature":"(.-)"')
                  or error("no match: request signature")

    local exp = config:match('"timestamp":(%d+)')
                  or error("no match: request timestamp")

    local s = "http://player.vimeo.com/play_redirect?clip_id=%s"
              .. "&sig=%s&time=%s&quality=%s&type=moogaloop_local"

    return string.format(s, self.id, sign, exp, quality)
end

function Vimeo.to_s(t)
    return string.format("%s", t.quality)
end

-- vim: set ts=4 sw=4 tw=72 expandtab:
