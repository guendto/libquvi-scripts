
SUBDIRS=	lua

DIST_lua=\
 lua/README \
 lua/util/content_type.lua \
 lua/util/charset.lua \
 lua/util/trim.lua \
 lua/website/README \
 lua/website/quvi/bit.lua \
 lua/website/quvi/const.lua \
 lua/website/quvi/html.lua \
 lua/website/quvi/url.lua \
 lua/website/quvi/util.lua \
 lua/website/101greatgoals.lua \
 lua/website/1tvru.lua \
 lua/website/academicearth.lua \
 lua/website/audioboo.lua \
 lua/website/bbc.lua \
 lua/website/break.lua \
 lua/website/canalplus.lua \
 lua/website/cbsnews.lua \
 lua/website/charlierose.lua \
 lua/website/clipfish.lua \
 lua/website/dailymotion.lua \
 lua/website/foxnews.lua \
 lua/website/funnyordie.lua \
 lua/website/gaskrank.lua \
 lua/website/golem.lua \
 lua/website/guardian.lua \
 lua/website/imdb.lua \
 lua/website/justintv.lua \
 lua/website/lego.lua \
 lua/website/liveleak.lua \
 lua/website/mgnetwork.lua \
 lua/website/metacafe.lua \
 lua/website/publicsenat.lua \
 lua/website/sapo.lua \
 lua/website/senat.lua \
 lua/website/sevenload.lua \
 lua/website/soundcloud.lua \
 lua/website/spiegel.lua \
 lua/website/tagtele.lua \
 lua/website/tapuz.lua \
 lua/website/ted.lua \
 lua/website/tvlux.lua \
 lua/website/tvrain.lua \
 lua/website/tmunderground.lua \
 lua/website/theonion.lua \
 lua/website/videa.lua \
 lua/website/videobash.lua \
 lua/website/vimeo.lua \
 lua/website/yfrog.lua \
 lua/website/youtube.lua

if WITH_NSFW
DIST_lua+=\
 lua/website/beeg.lua \
 lua/website/deviantclip.lua \
 lua/website/empflix.lua \
 lua/website/fastjizz.lua \
 lua/website/jizzhut.lua \
 lua/website/keezmovies.lua \
 lua/website/pornhub.lua \
 lua/website/redtube.lua \
 lua/website/spankwire.lua \
 lua/website/tcmag.lua \
 lua/website/tnaflix.lua \
 lua/website/totallynsfw.lua \
 lua/website/xhamster.lua \
 lua/website/xnxx.lua \
 lua/website/xvideos.lua \
 lua/website/youjizz.lua
endif

if WITH_FIXME
DIST_lua+=\
 lua/website/arte.lua \
 lua/website/bikeradar.lua \
 lua/website/blip.lua \
 lua/website/bloomberg.lua \
 lua/website/collegehumor.lua \
 lua/website/francetelevisions.lua \
 lua/website/globo.lua \
 lua/website/pluzz.lua
if WITH_NSFW
DIST_lua+=\
 lua/website/tube8.lua
endif
endif # WITH_FIXME

nobase_dist_pkgdata_DATA=	$(DIST_lua)
EXTRA_DIST=	$(DIST_lua)
