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

local CBSNews = {} -- Utility functions unique to this script

-- Identify the script.
function ident(qargs)
  return {
    can_parse_url = CBSNews.can_parse_url(qargs),
    domains = table.concat({'cbsnews.com'}, ',')
  }
end

-- Parse media URL.
function parse(self)
    self.host_id = "cbsnews"

    local c = CBSNews.get_config(self)

    self.title = c:match('<Title>.-CDATA%[(.-)%]')
                  or error ("no match: media title")

    local formats = CBSNews.iter_formats(c)
    local U       = require 'quvi/util'
    local format  = U.choose_format(self, formats,
                                     CBSNews.choose_best,
                                     CBSNews.choose_default,
                                     CBSNews.to_s)
                        or error("unable to choose format")
    self.url      = {format.url or error("no match: media url")}
    return self
end

--
-- Utility functions
--

function CBSNews.can_parse_url(qargs)
  local U = require 'socket.url'
  local t = U.parse(qargs.input_url)
  if t and t.scheme and t.scheme:lower():match('^http$')
       and t.host   and t.host:lower():match('^cbsnews%.com$')
       and t.path   and t.path:lower():match('^/video/watch/')
       and t.query  and t.query:lower():match('^id=[%w]+$')
  then
    return true
  else
    return false
  end
end

function CBSNews.get_config(self)
    local p = quvi.fetch(self.page_url)

    -- Need "? because some videos have the " and some don't
    self.id = p:match('CBSVideo.setVideoId%("?(.-)"?%);')
                or error("no match: media id")

    local s_fmt =
      "http://api.cnet.com/restApi/v1.0/videoSearch?videoIds=%s"
       .. "&iod=videoMedia"

    local c_url = string.format(s_fmt, self.id)

    return quvi.fetch(c_url, {fetch_type='config'})
end

function CBSNews.iter_formats(config) -- Iterate available formats
    local p = '<Width>(%d+)<'
           .. '.-<Height>(%d+)<'
           .. '.-<BitRate>(%d+)<'
           .. '.-<DeliveryUrl>.-'
           .. 'CDATA%[(.-)%]'
    local t = {}
    for w,h,b,u in config:gmatch(p) do
        local s = u:match('%.(%w+)$')
--        print(w,h,b,s,u)
        table.insert(t,
            {width=tonumber(w),
             height=tonumber(h),
             bitrate=tonumber(b),
             url=u,
             container=s})
    end
    return t
end

function CBSNews.choose_best(formats) -- Highest quality available
    local r = {width=0, height=0, bitrate=0, url=nil}
    local U = require 'quvi/util'
    for _,v in pairs(formats) do
        if U.is_higher_quality(v,r) then
            r = v
        end
    end
--    for k,v in pairs(r) do print(k,v) end
    return r
end

function CBSNews.choose_default(t) -- Lowest quality available
    local r = {width=0xffff, height=0xffff, bitrate=0xffff, url=nil}
    local U = require 'quvi/util'
    for _,v in pairs(t) do
        if U.is_lower_quality(v,r) then
            r = v
        end
    end
--    for k,v in pairs(r) do print(k,v) end
    return r
end

function CBSNews.to_s(t)
    return string.format("%s_%sk_%sp", t.container, t.bitrate, t.height)
end

-- vim: set ts=4 sw=4 tw=72 expandtab:
