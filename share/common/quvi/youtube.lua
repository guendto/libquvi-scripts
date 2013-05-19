-- libquvi-scripts
-- Copyright (C) 2012-2013  Toni Gundogdu <legatvs@gmail.com>
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

local M = {}

--[[
Return the `ident' data for the {media,subtitle} scripts.
Parameters:
  qargs .. quvi args
Returns:
  A table containing the values expected by the library.
]]--
function M.ident(qargs)
  local u = M.normalize(qargs.input_url)
  return {
    domains = table.concat({'youtube.com'}, ','),
    can_parse_url = M.can_parse_url(u)
  }
end

--[[
Check if script can parse the URL.
Parameters:
  url .. URL to check
Returns:
  A boolean value.
]]--
function M.can_parse_url(url)
  local U = require 'socket.url'
  local t = U.parse(url)
  if t and t.scheme and t.scheme:lower():match('^https?$')
       and t.host   and t.host:lower():match('youtube%.com$')
       and t.query  and t.query:lower():match('^v=[%w-_]+')
       and t.path   and t.path:lower():match('^/watch$')
  then
    return true
  else
    return false
  end
end

--[[
"Normalize" URL to YouTube media URL. See the test URLs for examples.
Parameters:
  s  .. URL to normalize
Returns:
  Normalized URL
]]--
function M.normalize(url)
  if not url then return url end

  local U = require 'socket.url'
  local t = U.parse(url)

  if not t.host then return url end

  t.host = t.host:gsub('youtu%.be', 'youtube.com')
  t.host = t.host:gsub('-nocookie', '')

  if t.path then
    local p = {'/embed/([-_%w]+)', '/%w/([-_%w]+)', '/([-_%w]+)'}
    for _,v in pairs(p) do
      local m = t.path:match(v)
      if m and #m == 11 then
        t.query = 'v=' .. m
        t.path  = '/watch'
      end
    end
  end
  return U.build(t)
end

--[[
Append URL to qargs.media_url if it is unique by comparing video IDs.
Parameters:
  url .. URL to append
]]--
function M.append_if_unique(qargs, url)
  if not url then return end

  url = M.normalize(url)

  local U = require 'socket.url'
  local t = U.parse(url)

  if not t.host or not t.query then return end

  local p = 'v=([%w-_]+)'
  local v = t.query:match(p)

  for _,u in pairs(qargs.media_url) do
    local tt = U.parse(u)
    if tt.query and  v == tt.query:match(p) then
      return -- Found duplicate. Ignore URL.
    end
  end

  table.insert(qargs.media_url, url)
end

-- Uncomment to test.
--[[
package.path = package.path .. ';../?.lua'
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
  local s = M.normalize(v.u)
  if s ~= v.e then
  print('\n   input: ' .. v.u .. " (#" .. i .. ")")
  print('expected: '   .. v.e)
  print('     got: '   .. s)
  e = e + 1
  end
end
print((e == 0) and 'Tests OK' or ('\nerrors: ' .. e))
]]--

return M

-- vim: set ts=2 sw=2 tw=72 expandtab:
