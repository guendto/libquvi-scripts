# Common scripts.

commondir=$(pkgdatadir)/$(VERSION)/common/quvi/

dist_common_DATA=\
  common/quvi/bit.lua\
  common/quvi/const.lua\
  common/quvi/debug.lua\
  common/quvi/entity.lua\
  common/quvi/html.lua\
  common/quvi/lxph.lua\
  common/quvi/stream.lua\
  common/quvi/util.lua\
  common/quvi/youtube.lua

# Utility scripts.

utildir=$(pkgdatadir)/$(VERSION)/util

dist_util_DATA=\
  util/resolve_redirections.lua\
  util/convert_entities.lua\
  util/to_file_ext.lua

# Media property scripts.

mediadir=$(pkgdatadir)/$(VERSION)/media

dist_media_DATA=\
  media/academicearth.lua\
  media/break.lua\
  media/dailymotion.lua\
  media/gaskrank.lua\
  media/vimeo.lua\
  media/youtube.lua
#  media/soundcloud.lua -- On hold: still under LGPLv2.1+

if WITH_GEOBLOCKED
dist_media_DATA+=
#  media/arte.lua -- On hold: still under LGPLv2.1+
endif

if WITH_NSFW
endif

if WITH_FIXME
if WITH_GEOBLOCKED
endif
if WITH_NSFW
endif
endif # WITH_FIXME

# Subtitle property scripts.

subtitleexportdir=$(pkgdatadir)/$(VERSION)/subtitle/export

dist_subtitleexport_DATA=\
  subtitle/export/subrip.lua

# Subtitle property scripts.

subtitledir=$(pkgdatadir)/$(VERSION)/subtitle

dist_subtitle_DATA=\
  subtitle/youtube.lua

# Playlist property scripts.

playlistdir=$(pkgdatadir)/$(VERSION)/playlist

dist_playlist_DATA=\
  playlist/youtube.lua
#  playlist/soundcloud.lua -- On hold: media script still under LGPLv2.1+

# Scan embedded media URL scripts.

scandir=$(pkgdatadir)/$(VERSION)/scan

dist_scan_DATA=\
  scan/youtube.lua

.PHONY: version

version:
	@if test -d "$(top_srcdir)/.git" -o -f "$(top_srcdir)/.git"; then \
		"$(top_srcdir)/gen-ver.sh" "$(top_srcdir)" > $@; \
	fi

dist-hook: version

versiondir=$(pkgdatadir)/$(VERSION)
dist_version_DATA=version

install-data-hook:
	cd $(DESTDIR)$(pkgdatadir) && rm -f $(VERSION_MM) && \
		$(LN_S) $(VERSION) $(VERSION_MM)
