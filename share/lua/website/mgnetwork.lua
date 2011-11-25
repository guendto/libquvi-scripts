--
-- quvi
-- Copyright (C) 2011  quvi project <http://quvi.sourceforge.net/>
--
-- This file is part of quvi <http://quvi.sourceforge.net/>.
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

-- Identify the script.
function ident(self)
    package.path = self.script_dir .. '/?.lua'
    local C      = require 'quvi/const'
    local r      = {}
    local domains= {'alabamas13%.com', 'counton2%.com',
        'dailyprogress%.com', 'dothaneagle%.com', 'eprisenow%.com',
        'eufaulatribune%.com', 'godanriver%.com', 'hickoryrecord%.com',
        'independenttribune%.com', 'insidenova%.com', 'jcfloridan%.com',
        'journalnow%.com', 'oanow%.com', 'morganton%.com',
        'nbc4i%.com', 'nbc17%.com', 'newsadvance%.com',
        'newsvirginian%.com', 'richmond%.com', 'sceneon7%.com',
        'scnow%.com', 'starexponent%.com', 'statesville%.com',
        'tbo%.com', 'timesdispatch%.com', 'tricities%.com',
        'turnto10%.com', 'wnct%.com', 'whlt%.com', 'wjbf%.com',
        'wjtv%.com', 'wkrg%.com', 'wrbl%.com', 'wsav%.com', 'wsls%.com',
        'wspa%.com', 'vteffect%.com'}
    r.domain     = 'mgnetwork%.com'
    r.formats    = 'default'
    r.categories = C.proto_http
    local U      = require 'quvi/util'
    r.handles    = U.handles(self.page_url,
            domains,
            {"/%w+/.+%-%d+"})
    return r
end

-- Query available formats.
function query_formats(self)
    self.formats = 'default'
    return self
end

-- Parse media URL.
function parse(self)
    self.host_id         = 'mgnetwork'

    local _,_,domain,v,s = self.page_url:find("http://([%w%.]+)/.+%-(%w+)%-(%d+)/")
    self.id              = s

    local page           = quvi.fetch(self.page_url)
    local _,_,config_url = page:find("if %(!mrss_link%){ mrss_link = " ..
        "'(.-)'; }")
    if not config_url or config_url == '' then
        error('no match: no video found on page')
    end

    --local config_url     = string.format(
    --    'http://%s/video/get/media_response_related_' ..
    --    'for_content/%s/%d/', domain, v, self.id)
    local opts           = {fetch_type = 'config'}
    local xml            = quvi.fetch(config_url, opts)

    local _,_,item       = xml:find('<item>(.-)</item>')
    local _,_,s          = item:find('<title>(.-)</title>')
    self.title           = s

    self.url             = {}
    for s,d in item:gfind('<media:content url="(.-)" ' ..
                            'type="video/mp4" duration="([%d\.]-)"') do
        table.insert(self.url, s)
        self.duration    = tonumber(d) or 0
    end

    local _,_,t          = xml:find('<media:thumbnail url="(.-)"')
    self.thumbnail_url   = t

    return self
end

-- vim: set ts=4 sw=4 tw=72 expandtab:
