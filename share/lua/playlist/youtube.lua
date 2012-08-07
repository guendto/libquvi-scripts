-- libquvi-scripts
-- Copyright (C) 2012  Toni Gundogdu <legatvs@gmail.com>
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

-- Identify the playlist script.
function ident(qargs)
  local A = require 'quvi/accepts'
  local r = {
    accepts = A.accepts(qargs.input_url, {"youtube%.com"}, nil, {"list=%w+"})
  }
  return r
end

-- Parse playlist properties.
function parse(qargs)

  qargs.id = qargs.input_url:match('list=(%w+)')
  while #qargs.id > 16 do -- Strip playlist ID prefix (e.g. "PL")
    qargs.id = qargs.id:gsub("^%w", "")
  end
  if #qargs.id < 16 then
    error('no match: playlist ID')
  end

  local Y = require 'quvi/youtube'
  local P = require 'lxp.lom'

  local max_results = 25
  local start_index = 1

  qargs.media = {}

  local C = require 'quvi/const'
  local o = { [C.qfo_type] = C.qft_playlist }

  local r = {}

  -- TODO: Return playlist thumbnail URL
  -- TODO: Return playlist title

  repeat -- Get the entire playlist.
    local u = YouTube.config_url(qargs, start_index, max_results)
    local c = quvi.fetch(u, o)
    local x = P.parse(c)

    YouTube.chk_error_resp(x)
    r = YouTube.parse_media_urls(x)

    for _,u in pairs(r) do
      local t = {
        url = u
      }
      table.insert(qargs.media, t)
    end

    start_index = start_index + #r
  until #r == 0

  return qargs
end

--
-- Utility functions
--

function YouTube.config_url(qargs, start_index, max_results)
  return string.format( -- Refer to http://is.gd/0msY8X
    'http://gdata.youtube.com/feeds/api/playlists/%s?v=2'
    .. '&start-index=%s&max-results=%s&strict=true',
      qargs.id, start_index, max_results)
end

function YouTube.parse_media_urls(t)
  -- TODO: Return media duration_ms
  -- TODO: Return media title
  local r = {}
  if not t then return r end
  for i=1, #t do
    if t[i].tag == 'entry' then
      for j=1, #t[i] do
        if t[i][j].tag == 'link' then
          if t[i][j].attr['rel'] == 'alternate' then
            table.insert(r, t[i][j].attr['href'])
          end
        end
      end
    end
  end
  return r
end

function YouTube.chk_error_resp(t)
  if not t then return end
  local r = {}
  for i=1, #t do
    if t[i].tag == 'error' then
      for j=1, #t[i] do
        if t[i][j].tag == 'domain' then
          r.domain = t[i][j][1]
        end
        if t[i][j].tag == 'code' then
          r.code = t[i][j][1]
        end
        if t[i][j].tag == 'internalReason' then
          r.reason = t[i][j][1]
        end
        if t[i][j].tag == 'location' then -- Ignores 'type' attribute.
          r.location = t[i][j][1]
        end
      end
    end
  end
  if #r >0 then
    local m
    for k,v in pairs(r) do
      m = m .. string.format("%s=%s ", k,v)
    end
    error(m)
  end
end

-- vim: set ts=2 sw=2 tw=72 expandtab:
