-- libquvi-scripts
-- Copyright (C) 2012  Toni Gundogdu <legatvs@gmail.com>
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

--
-- Checks the availability of a Lua module.
--
-- NOTES:
--  * Exits with either 0 (success) or 1 (failure)
--  * Informative messages are printed to stdout
--

local EXIT_SUCCESS = 0
local EXIT_FAILURE = 1

local function _chk_input()
  if #arg <2 then
    print(string.format('Usage: %s <modname> <reqver>', arg[0]))
    print('  Exit status: 0=success, 1=failure')
    print(string.format('Example: %s lxp 1.2.0', arg[0]))
    os.exit(EXIT_FAILURE)
  end
end

local function _chk_form(a,b,c,s)
  if not a or not b or not c then
    print(string.format('error: %s must be in the x.y.z form', s))
    os.exit(EXIT_FAILURE)
  end
end

local function _to_n(a,b,c)
  return tonumber(string.format('%d%d%d',
                    tonumber(a), tonumber(b), tonumber(c)))
end

local function _chk_mod(m,r)
  local p = '(%d+).(%d+).(%d+)'

  local ra,rb,rc = r:match(p)
  _chk_form(ra,rb,rc,'reqver')

  local M = require(m)

  local fa,fb,fc = M._VERSION:match(p)
  _chk_form(fa,fb,fc,'modver')

  print('require', ra,rb,rc)
  print('found', fa,fb,fc)

  return (_to_n(fa,fb,fc) >= _to_n(ra,rb,rc))
            and EXIT_SUCCESS or EXIT_FAILURE
end

_chk_input()
os.exit(_chk_mod(arg[1], arg[2]))
