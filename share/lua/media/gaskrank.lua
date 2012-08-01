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

local Gaskrank = {} -- Utility functions unique to this script

-- Identify the media script.
function ident(qargs)
  local A = require 'quvi/accepts'
  local C = require 'quvi/const'
  local r = {
    accepts = A.accepts(qargs.input_url, {"gaskrank%.tv"}, {"/tv/"}),
    categories = C.proto_http
  }
  return r
end

-- Parse media properties.
function parse(qargs)
  local p = quvi.fetch(qargs.input_url)

  qargs.thumb_url = p:match('"og:image" content="(.-)"') or ''

  qargs.title = p:match('"og:title" content="(.-)"') or ''

  qargs.id = qargs.input_url:match("%-(%d+)%.h")
              or error("no match: media ID")

  qargs.streams = Gaskrank.iter_streams(p)

  return qargs
end

--
-- Utility functions.
--

function Gaskrank.iter_streams(p)
  local u = p:match("(http://movies.-%.flv)")
              or error("no match: media stream URL")
  local S = require 'quvi/stream'
  return {S.stream_new(u)}
end

-- vim: set ts=2 sw=2 tw=72 expandtab:
