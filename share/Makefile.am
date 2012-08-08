SUBDIRS=lua
DIST_lua=lua/README

# Common scripts.

DIST_lua+=\
  lua/common/quvi/accepts.lua\
  lua/common/quvi/bit.lua\
  lua/common/quvi/const.lua\
  lua/common/quvi/debug.lua\
  lua/common/quvi/entity.lua\
  lua/common/quvi/html.lua\
  lua/common/quvi/lxph.lua\
  lua/common/quvi/stream.lua\
  lua/common/quvi/url.lua\
  lua/common/quvi/util.lua\
  lua/common/quvi/youtube.lua

# Utility scripts.

DIST_lua+=\
  lua/util/resolve_redirections.lua\
  lua/util/convert_entities.lua\
  lua/util/to_file_ext.lua

# Media property scripts.

DIST_lua+=\
  lua/media/academicearth.lua\
  lua/media/break.lua\
  lua/media/dailymotion.lua\
  lua/media/gaskrank.lua\
  lua/media/soundcloud.lua\
  lua/media/vimeo.lua\
  lua/media/youtube.lua

if WITH_GEOBLOCKED
DIST_lua+=\
  lua/media/arte.lua
endif

if WITH_NSFW
endif

if WITH_FIXME
if WITH_GEOBLOCKED
endif
if WITH_NSFW
endif
endif # WITH_FIXME

# Playlist property scripts.

DIST_lua+=\
  lua/playlist/soundcloud.lua\
  lua/playlist/youtube.lua

# Scan embedded media URL scripts.

DIST_lua+=\
  lua/scan/youtube.lua

nobase_dist_pkgdata_DATA=	$(DIST_lua)
EXTRA_DIST=	$(DIST_lua)
