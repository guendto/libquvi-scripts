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
  lua/media/arte.lua\
  lua/media/break.lua\
  lua/media/gaskrank.lua\
  lua/media/dailymotion.lua\
  lua/media/vimeo.lua\
  lua/media/youtube.lua

# Media property scripts that are NSFW.
if WITH_NSFW
#DIST_lua+=
endif

# Media property scripts that are need fixing.
if WITH_FIXME
#DIST_lua+=
# Media property scripts that need fixing and are NSFW.
if WITH_NSFW
#DIST_lua+=
endif
endif # WITH_FIXME

nobase_dist_pkgdata_DATA=	$(DIST_lua)
EXTRA_DIST=	$(DIST_lua)
