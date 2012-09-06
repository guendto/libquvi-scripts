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

local M = {}

-- (q)uvi (m)edia (s)cript (p)rotocol (c)ategory
M.qmspc_https = 0x1
M.qmspc_http  = 0x2
M.qmspc_rtmpt = 0x4
M.qmspc_rtmps = 0x8
M.qmspc_rtmpe = 0x10
M.qmspc_rtmp  = 0x20
M.qmspc_rtsp  = 0x40
M.qmspc_mms   = 0x80

M.qmspc_http_family = 0x3
M.qmspc_rtmp_family = 0x3c

-- (q)uvi.(f)etch (o)ption
M.qfo_from_charset = 0x0 -- Convert (to UTF-8) from this charset
M.qfo_user_agent   = 0x1 -- Set user-agent string value
M.qfo_cookie       = 0x2 -- Set an arbitrary cookie
M.qfo_type         = 0x3 -- Fetch type (see qft_*)

-- (q)uvi.(f)etch (t)ype
M.qft_playlist = 0x0
M.qft_config   = 0x1
M.qft_url      = 0x2 -- default

--[[
NOTES
=====

qfo_from_charset
----------------
Instructs the library to convert from this charset to UTF-8. Using this
option may be required with the websites that use a specific (non-UTF8)
encoding.

The purpose of this option is to make sure that the data is encoded to
unicode (UTF-8) before any of it is parsed and returned to the
application using libquvi.

By default, libquvi converts the data which is in the encoding used for
the strings by the C runtime in the current locale into UTF-8.  IF this
fails, and the 'from charset' option is set, the library will then try
to convert to UTF-8 using the 'from charset' value.

qfo_cookie
----------
When set, the arbitrary cookie will be used with the quvi.fetch .
The cookies are handled by libcurl, look up the CURLOPT_COOKIE
description for details. If you must define >1 cookies, use the
following format: "foo=1; bar=2;" .

EXAMPLES
========
local C = require 'quvi/const'

local p = quvi.fetch(URL, {[C.qfo_cookie] = 'foo=1'})
local p = quvi.fetch(URL, {[C.qfo_type] = C.qft_config})

local t = {
  [C.qfo_cookie] = 'foo=1; bar=2;',
  [C.qfo_type] = C.qft_config
}
local p = quvi.fetch(URL, t)
]]--

return M

-- vim: set ts=2 sw=2 tw=72 expandtab:
