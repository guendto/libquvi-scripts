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

local ResolveExceptions = {} -- Utility functions unique to this script

function resolve_redirections(qargs)
  -- Let libcURL resolve the URL redirections for us.
  local r = quvi.resolve(qargs.input_url)
  if #r.resolved_url ==0 then return qargs.input_url end

  -- Apply any exception rules to the destination URL.
  return ResolveExceptions.YouTube(qargs, r.resolved_url)
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
