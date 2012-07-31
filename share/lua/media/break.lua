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

local Break = {} -- Utility functions unique to this script

-- Identify the media script.
function ident(qargs)
  local A = require 'quvi/accepts'
  local C = require 'quvi/const'
  local r = {
    accepts = A.accepts(qargs.input_url, {"break%.com"}, {"/index/"}),
    categories = C.proto_http
  }
  return r
end

-- Parse media properties.
function parse(qargs)
  local p = quvi.fetch(qargs.input_url)

  qargs.title = p:match('id="vid_title" content="(.-)"') or ''
  qargs.id = p:match("ContentID='(.-)'") or ''

  local n = p:match("FileName='(.-)'") or error("no match: file name")
  local h = p:match('flashVars.icon = "(.-)"') or error("no match: file hash")

  qargs.streams = Break.iter_streams(n, h)

  return qargs
end

--
-- Utility functions.
--

function Break.iter_streams(n, h)
  local u = string.format("%s.flv?%s", n, h)
  local S = require 'quvi/stream'
  return {S.stream_new(u)}
end

-- vim: set ts=4 sw=4 tw=72 expandtab:
