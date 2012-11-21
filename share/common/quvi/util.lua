-- libquvi-scripts
-- Copyright (C) 2010-2012  Toni Gundogdu <legatvs@gmail.com>
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
Check whether a string A ends with string B.
Parameters:
  a .. String A
  b .. String B
Returns:
  true if string A ends with string B.
]]--
function M.ends(a, b) -- http://lua-users.org/wiki/StringRecipes
  return a:sub(-#b) == b
end

--[[
Compare quality properties of two media entities. Compares the height, then
the width, followed by the bitrate property comparison (if it is set).
Parameters:
  a .. Media entity A
  b .. Media entity B
Returns:
  true if entity A is the higher quality, otherwise false.
]]--
function M.is_higher_quality(a, b)
  if a.height > b.height then
    if a.width > b.width then
      if a['bitrate'] then -- Optional
        if a.bitrate > b.bitrate then return true end
      else
        return true
      end
    end
  end
  return false
end

--[[
Compare quality properties of two media entities. Compares the height, then
the width, followed by the bitrate property comparison (if it is set).
Parameters:
  a .. Media entity A
  b .. Media entity B
Returns:
  true if entity A is the lower quality, otherwise false.
]]--
function M.is_lower_quality(a, b)
  if a.height < b.height then
    if a.width < b.width then
      if a['bitrate'] then -- Optional
        if a.bitrate < b.bitrate then return true end
      else
        return true
      end
    end
  end
  return false
end

--[[
Tokenize a string.
Parameters:
  s .. String to tokenize
  p .. Pattern (e.g. "[%w-_]+")
Returns:
  An array of tokens.
]]--
function M.tokenize(s, p)
  return s:gmatch(p)
end

--[[
Convert a string to a timestamp.
Parameters:
  s .. String to convert
Returns:
  Converted string.
]]--
function M.to_timestamp(s) -- Based on <http://is.gd/ee9ZTD>
  local p = "%a+, (%d+) (%a+) (%d+) (%d+):(%d+):(%d+)"

  local d,m,y,hh,mm,ss = s:match(p)
  if not d then error('no match: date') end

  local MON = {Jan=1, Feb=2, Mar=3, Apr=4, May=5, Jun=6, Jul=7, Aug=8,
               Sep=9, Oct=10, Nov=11, Dec=12}

  local m = MON[m]
  local offset = os.time() - os.time(os.date("!*t"))

  return os.time({day=d,month=m,year=y,
                  hour=hh,min=mm,sec=ss}) + offset
end

--[[
Decode a string.
Parameters:
  s .. String to decode
Returns:
  Decoded string.
]]--
function M.decode(s) -- http://www.lua.org/pil/20.3.html
  r = {}
  for n,v in s:gmatch ("([^&=]+)=([^&=]+)") do
    n = M.unescape(n)
    r[n] = v
  end
  return r
end

--[[
Unescape a string.
Parameters:
  s .. String to unescape
Returns:
  Unescaped string
]]--
function M.unescape(s) -- http://www.lua.org/pil/20.3.html
  s = s:gsub('+', ' ')
  return (s:gsub('%%(%x%x)',
            function(h)
              return string.char(tonumber(h, 16))
            end))
end

--[[
Unescape slashed string.
Parameters:
  s .. String to unescape
Returns:
  Unescaped string
]]--
function M.slash_unescape(s)
  return (s:gsub('\\(.)', '%1'))
end

return M

-- vim: set ts=2 sw=2 tw=72 expandtab:
