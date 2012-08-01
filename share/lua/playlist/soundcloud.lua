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

-- Identify the playlist script.
function ident(qargs)
  local A = require 'quvi/accepts'
  local r = {
    accepts = A.accepts(qargs.input_url,
                          {"soundcloud%.com"}, {'/sets/[%w-_]+/'})
  }
  return r
end

-- Parse playlist properties.
function parse(qargs)

  qargs.id, s = qargs.input_url:match('/([%w-_]+)/sets/([%w-_]+)/')
  if qargs.id and s then
    qargs.id = qargs.id .."_".. s
  end

  local p = quvi.fetch(qargs.input_url, {type='playlist'})

  qargs.media_url = {}
  for u in p:gmatch('class="info">.-href="(.-)"') do
    table.insert(qargs.media_url, "http://soundcloud" ..u)
  end

  return qargs
end

-- vim: set ts=2 sw=2 tw=72 expandtab:
