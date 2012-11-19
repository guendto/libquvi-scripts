
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

local ResolveExceptions = {} -- Utility functions unique to this script

function resolve_redirections(qargs)
  -- Let libcURL resolve the URL redirections for us.
  local resolved, dst = quvi.resolve(qargs.input_url)
  if not resolved then return qargs.input_url end

  -- Apply any exception rules to the destination URL.
  return ResolveExceptions.YouTube(qargs, dst)
end

--
-- Utility functions
--

function ResolveExceptions.YouTube(qargs, dst)
  -- [UPDATE] 2012-11-18: g00gle servers seem not to strip the #t anymore
  return dst
--[[
  -- Preserve the t= parameter (if any). The g00gle servers
  -- strip them from the destination URL after redirecting.
  -- e.g. http://www.youtube.com/watch?v=LWxTGJ3TK1U#t=2m22s
  --   -> http://www.youtube.com/watch?v=LWxTGJ3TK1U
  return dst .. (qargs.input_url:match('(#t=%w+)') or '')
]]--
end

-- vim: set ts=2 sw=2 tw=72 expandtab:
