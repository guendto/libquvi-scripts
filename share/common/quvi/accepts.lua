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

local M = {}

--[[
Check whether a media script accepts the URL
Parameters:
  url     .. video page URL
  domains .. table of domain names
  paths   .. table of URL path patterns to match
  queries .. table of URL query patterns to match
Returns:
  true if media scripts accepts the URL, otheriwise false
]]--
function M.accepts(url, domains, paths, queries)

  if not url or not domains then
    return {accepts=false, domains={}}
  end

  local U = require 'quvi/util'
  local R = require 'quvi/url'

  local t = R.parse(url)
  local a = U.match_any(domains, t.host)
--  for k,v in pairs(t) do print(k,v) end

  if a then

    if paths then
      a = U.match_any(paths, t.path)
    end -- if paths

    if a then
      if queries then
        if t.query then
          a = U.match_any(queries, t.query)
        else
          a = false
        end
      end -- if queries
    end -- if a

  end -- if a

  for _,v in pairs(domains) do
    v = v:gsub('%%w%+', 'com') -- Naive replacement.
    v = v:gsub('%%', '')       -- Strip any remaining Lua escape characters.
    v = v:gsub('%s', '')       -- Strip any whitespace.
    table.insert(t, v)
  end

  return {accepts=a, domains=table.concat(t,',')}
end

--[[
package.path = package.path .. ';../?.lua'

local function dump(r)
  print('--')
  for k,v in pairs(r) do print(k,v) end
end

local function foo()
  -- should return true
  dump(M.accepts('http://example.com', {'example%.%w+'}))
  -- should return false
  dump(M.accepts('http://example.com', {'examle%.%w+'}))
end

local function bar()
  local d = {'example.%w+', 'foo.bar'}
  -- should return true
  dump(M.accepts('http://example.com/foo/bar', d, {'/foo/'}))
  -- should return true
  dump(M.accepts('http://foo.bar/baz/1234_fubar', d, {'/baz/'}))
  -- should return false
  dump(M.accepts('http://foobar/baz/1234_fubar', d, {'/baz/'}))
end

foo()
bar()
]]--

return M

-- vim: set ts=2 sw=2 tw=72 expandtab:
