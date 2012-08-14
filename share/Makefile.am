SUBDIRS=lua
DIST_lua=README

# Common scripts.

DIST_lua+=\
  common/quvi/accepts.lua\
  common/quvi/bit.lua\
  common/quvi/const.lua\
  common/quvi/debug.lua\
  common/quvi/entity.lua\
  common/quvi/html.lua\
  common/quvi/lxph.lua\
  common/quvi/stream.lua\
  common/quvi/url.lua\
  common/quvi/util.lua\
  common/quvi/youtube.lua

# Utility scripts.

DIST_lua+=\
  util/resolve_redirections.lua\
  util/convert_entities.lua\
  util/to_file_ext.lua

# Media property scripts.

DIST_lua+=\
  media/academicearth.lua\
  media/arte.lua\
  media/break.lua\
  media/dailymotion.lua\
  media/gaskrank.lua\
  media/soundcloud.lua\
  media/vimeo.lua\
  media/youtube.lua

if WITH_NSFW
endif

if WITH_FIXME
if WITH_NSFW
endif
endif # WITH_FIXME

# Playlist property scripts.

DIST_lua+=\
  playlist/soundcloud.lua\
  playlist/youtube.lua

# Scan embedded media URL scripts.

DIST_lua+=\
  scan/youtube.lua

nobase_dist_pkgdata_DATA=	$(DIST_lua)
EXTRA_DIST=	$(DIST_lua)
