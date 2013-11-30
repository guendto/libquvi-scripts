# README.

rootdir=$(pkgdatadir)/$(VERSION)

dist_root_DATA=\
  README

# Common scripts.

commondir=$(pkgdatadir)/$(VERSION)/common/quvi/

dist_common_DATA=\
  common/quvi/const.lua\
  common/quvi/debug.lua\
  common/quvi/entity.lua\
  common/quvi/hash.lua\
  common/quvi/hex.lua\
  common/quvi/html.lua\
  common/quvi/lxph.lua\
  common/quvi/stream.lua\
  common/quvi/time.lua\
  common/quvi/util.lua\
  common/quvi/youtube.lua

common_httpdir=$(pkgdatadir)/$(VERSION)/common/quvi/http/

dist_common_http_DATA=\
  common/quvi/http/cookie.lua

# Utility scripts.

utildir=$(pkgdatadir)/$(VERSION)/util

dist_util_DATA=\
  util/convert_entities.lua\
  util/resolve_redirections.lua\
  util/to_file_ext.lua

# Media property scripts.

mediadir=$(pkgdatadir)/$(VERSION)/media

dist_media_DATA=\
  media/101greatgoals.lua\
  media/1tvru.lua\
  media/ardmediathek.lua\
  media/audioboo.lua\
  media/bikeradar.lua\
  media/canalplus.lua\
  media/cbsnews.lua\
  media/clipfish.lua\
  media/collegehumor.lua\
  media/dailymotion.lua\
  media/dorkly.lua\
  media/funnyordie.lua\
  media/ina.lua\
  media/gaskrank.lua\
  media/guardian.lua\
  media/lego.lua\
  media/liveleak.lua\
  media/majestyc.lua\
  media/metacafe.lua\
  media/myspass.lua\
  media/publicsenat.lua\
  media/sapo.lua\
  media/senat.lua\
  media/sevenload.lua\
  media/soundcloud.lua\
  media/spiegel.lua\
  media/tagtele.lua\
  media/tapuz.lua\
  media/ted.lua\
  media/theonion.lua\
  media/tvlux.lua\
  media/videa.lua\
  media/videobash.lua\
  media/vimeo.lua\
  media/vzaar.lua\
  media/youtube.lua

if WITH_GEOBLOCKED
dist_media_DATA+=\
  media/arte.lua
endif

if WITH_NSFW
endif

if WITH_FIXME
dist_media_DATA+=\
  media/break.lua\
  media/charlierose.lua
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
  playlist/soundcloud.lua\
  playlist/youtube.lua

# Scan embedded media URL scripts.

scandir=$(pkgdatadir)/$(VERSION)/scan

dist_scan_DATA=\
  scan/vzaar.lua\
  scan/youtube.lua

install-data-hook:
	cd $(DESTDIR)$(pkgdatadir) && rm -f $(VERSION_MM) && \
		$(LN_S) $(VERSION) $(VERSION_MM) ; \
	cd $(VERSION_MM) && echo "[libquvi-scripts]" >version && \
		echo "configuration = $(BUILD_OPTS)" >>version && \
		echo "version = v$(VERSION)" >>version

uninstall-hook:
	rm -rf "$(DESTDIR)$(pkgdatadir)/$(VERSION)" ; \
	rm -f "$(DESTDIR)$(pkgdatadir)/$(VERSION_MM)"

# vim: set ts=2 sw=2 tw=72 expandtab:
