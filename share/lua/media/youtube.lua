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

local YouTube = {} -- Utility functions unique to this script

-- <http://en.wikipedia.org/wiki/YouTube#Quality_and_codecs>

-- Identify the script.
function ident(self)
  local A = require 'quvi/accepts'
  local Y = require 'quvi/youtube'
  local C = require 'quvi/const'
  local u = Y.normalize(qargs.input_url)
  local r = {
    accepts = A.accepts(u, {"youtube%.com"}, {"/watch"}, {"v=[%w-_]+"}),
    categories = C.proto_http
  }
  return r
end

-- Parse media properties.
function parse(self)
  local Y = require 'quvi/youtube'
  return YouTube.parse_properties(qargs, Y)
end

--
-- Utility functions
--

-- Parses the video info from the server.
function YouTube.parse_properties(qargs, Y)
  local c, U = YouTube.get_data(qargs, Y)

  qargs.duration_ms = (c['length_seconds'] or 0)*1000 -- to ms
  qargs.thumb_url = U.unescape(c['thumbnail_url'] or '')
  qargs.title = U.unescape(c['title'] or '')
  qargs.streams = YouTube.iter_streams(c, U)
  YouTube.append_begin_param(qargs)

  return qargs
end

-- Queries the video data from the server.
function YouTube.get_data(qargs, Y)
  local u = Y.normalize(qargs.input_url)

  qargs.id = u:match('v=([%w-_]+)')
              or error('no match: media ID')

  local U = require 'quvi/url'
  local u = U.parse(u)
  local s = u.scheme or error('no match: scheme')

  local s_fmt = '%s://www.youtube.com/get_video_info?&video_id=%s'
                  .. '&el=detailpage&ps=default&eurl=&gl=US&hl=en'

  local c_url = string.format(s_fmt, s, qargs.id)

  local U = require 'quvi/util'
  local c = U.decode(quvi.fetch(c_url, {type = 'config'}))

  if c['reason'] then
    local reason = U.unescape(c['reason'])
    local code = c['errorcode']
    error(string.format("%s (code=%s)", reason, code))
  end

  return c, U
end

function YouTube.iter_formats(config, U)
    local fmt_stream_map = config['url_encoded_fmt_stream_map']
                        or error("no match: url_encoded_fmt_stream_map")

    fmt_stream_map = U.unescape(fmt_stream_map) .. ","

    local urls = {}
    for f in fmt_stream_map:gmatch('([^,]*),') do
        local d = U.decode(f)
        if d['itag'] and d['url'] then
            urls[U.unescape(d['itag'])] = U.unescape(d['url'])
        end
    end

    local fmt_map = config['fmt_list'] or error("no match: fmt_list")
    fmt_map = U.unescape(fmt_map)

    local r = {}
    for f,w,h in fmt_map:gmatch('(%d+)/(%d+)x(%d+)') do
--        print(f,w,h)
        table.insert(r, {fmt_id=tonumber(f),    url=urls[f],
                          width=tonumber(w), height=tonumber(h)})
    end

    return r
end

function YouTube.get_video_info(self)
    local config,U = YouTube.get_config(self)

    self.title = config['title'] or error('no match: media title')
    self.title = U.unescape(self.title)

    self.thumbnail_url = config['thumbnail_url'] or ''
    if #self.thumbnail_url > 0 then
        self.thumbnail_url = U.unescape(self.thumbnail_url)
    end
    
    self.duration = (config['length_seconds'] or 0)*1000 -- to msec

    self.requested_format =
        YouTube.convert_deprecated_id(self.requested_format)

    local formats = YouTube.iter_formats(config, U)
    local format  = U.choose_format(self, formats,
                                    YouTube.choose_best,
                                    YouTube.choose_default,
                                    YouTube.to_s)
                        or error("unable to choose format")
    local url     = format.url or error("no match: media url")

    if url and #self.start_time > 0 then
        local min, sec = self.start_time:match("^(%d+)m(%d+)s$")
        min = tonumber(min) or 0
        sec = tonumber(sec) or 0
        local msec = (min * 60000) + (sec * 1000)
        if msec > 0 then
            url = url .. "&begin=" .. msec
        end
    end

    self.url = {url}
    return self
end

function YouTube.choose_best(formats) -- Highest quality available
    local r = {width=0, height=0, url=nil}
    local U = require 'quvi/util'
    for _,v in pairs(formats) do
        if U.is_higher_quality(v,r) then
            r = v
        end
    end
--    for k,v in pairs(r) do print(k,v) end
    return r
end

function YouTube.choose_default(formats)
    local r = formats[1] -- Either whatever YouTube returns as the first.
    for _,v in pairs(formats) do
        if v.height == 480 then -- Or, whichever is of 480p and found first.
            r = v
            break
        end
    end
    return r
end

YouTube.conv_table = { -- Deprecated.
    -- flv
    flv_240p =  '5',
    flv_360p = '34',
    flv_480p = '35',
    -- mp4
     mp4_360p = '18',
     mp4_720p = '22',
    mp4_1080p = '37',
    mp4_3072p = '38'
}

function YouTube.convert_deprecated_id(r_fmt)
    if YouTube.conv_table[r_fmt] then
        local s = string.format("fmt%02d_", YouTube.conv_table[r_fmt])
        r_fmt = r_fmt:gsub("^(%w+)_", s)
    end
    return r_fmt
end

function YouTube.to_s(t)
    return string.format("fmt%02d_%sp", t.fmt_id, t.height)
end

--[[
local a = {
  {u='http://youtu.be/3WSQH__H1XE',             -- u=page url
   e='http://youtube.com/watch?v=3WSQH__H1XE'}, -- e=expected url
  {u='http://youtu.be/v/3WSQH__H1XE?hl=en',
   e='http://youtube.com/watch?v=3WSQH__H1XE'},
  {u='http://youtu.be/watch?v=3WSQH__H1XE',
   e='http://youtube.com/watch?v=3WSQH__H1XE'},
  {u='http://youtu.be/embed/3WSQH__H1XE',
   e='http://youtube.com/watch?v=3WSQH__H1XE'},
  {u='http://youtu.be/v/3WSQH__H1XE',
   e='http://youtube.com/watch?v=3WSQH__H1XE'},
  {u='http://youtu.be/e/3WSQH__H1XE',
   e='http://youtube.com/watch?v=3WSQH__H1XE'},
  {u='http://youtube.com/watch?v=3WSQH__H1XE',
   e='http://youtube.com/watch?v=3WSQH__H1XE'},
  {u='http://youtube.com/embed/3WSQH__H1XE',
   e='http://youtube.com/watch?v=3WSQH__H1XE'},
  {u='http://jp.youtube.com/watch?v=3WSQH__H1XE',
   e='http://jp.youtube.com/watch?v=3WSQH__H1XE'},
  {u='http://jp.youtube-nocookie.com/e/3WSQH__H1XE',
   e='http://jp.youtube.com/watch?v=3WSQH__H1XE'},
  {u='http://jp.youtube.com/embed/3WSQH__H1XE',
   e='http://jp.youtube.com/watch?v=3WSQH__H1XE'},
  {u='http://youtube.com/3WSQH__H1XE', -- invalid page url
   e='http://youtube.com/watch?v=3WSQH__H1XE'}
}
local e = 0
for i,v in pairs(a) do
  local s = YouTube.normalize(v.u)
  if s ~= v.e then
    print('\n   input: ' .. v.u .. " (#" .. i .. ")")
    print('expected: '   .. v.e)
    print('     got: '   .. s)
    e = e + 1
  end
end
print((e == 0) and 'Tests OK' or ('\nerrors: ' .. e))
]]--

-- vim: set ts=4 sw=4 tw=72 expandtab:
