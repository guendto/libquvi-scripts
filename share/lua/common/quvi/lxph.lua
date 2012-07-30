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

--
-- NOTE: These are helper functions to be used with lua-expat (lxp)
--

local M = {}

--
-- Find first element with the matching tag.
--
-- Returns: The matching table element.
--
function M.find_first_tag(t, tag)
  for i=1, #t do
    if t[i].tag == tag then
      return t[i]
    end
  end
  error("[find_first_tag] no match: tag=" .. tag)
end

--[[
function M.foo()
  local xml = '<foo><bar>baz</bar></foo>'
  require 'lxp.lom'
  local t = lxp.lom.parse(xml)
  local e = M.find_first_tag(t, 'bar')
  if e[1] ~= 'baz' then error('should be "baz"') end
end
M.foo()
]]--

return M

-- vim: set ts=2 sw=2 tw=72 expandtab:
