#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.68])

m4_include([m4/version.m4])

AC_INIT([libquvi-scripts], [_LIBQUVI_SCRIPTS_VERSION],
  [http://sourceforge.net/apps/trac/quvi/], [],
  [http://quvi.sourceforge.net/])

AC_CONFIG_AUX_DIR([config.aux])
AC_CONFIG_MACRO_DIR([m4])

AM_INIT_AUTOMAKE([-Wall -Werror foreign dist-bzip2 dist-xz])
AM_SILENT_RULES([yes])

# Checks for programs.

AC_PATH_PROG([QUVI], [quvi], [], [$QUVI_PATH$PATH_SEPARATOR$PATH])
AM_CONDITIONAL([HAVE_QUVI], [test -n "$QUVI"])
AS_IF([test -n "$QUVI"], [quviver=`$QUVI --version | head -n1 2>/dev/null`])
AC_SUBST([QUVI])

AC_PATH_PROG([PROVE], [prove], [], [$PROVE_PATH$PATH_SEPARATOR$PATH])
AM_CONDITIONAL([HAVE_PROVE], [test -n "$PROVE"])
AC_SUBST([PROVE])

AC_PATH_PROG([VALGRIND], [valgrind], [], [$VALGRIND_PATH$PATH_SEPARATOR$PATH])
AM_CONDITIONAL([HAVE_VALGRIND], [test -n "$VALGRIND"])
AC_SUBST([VALGRIND])

# Version.
genver="$srcdir/gen-ver.sh"
AS_IF([test -x "$genver"], [VN=`"$genver" "$srcdir"`])
AM_CONDITIONAL([HAVE_VN], [test -n "$VN"])

# --with-tests
AC_ARG_WITH([tests],
  [AS_HELP_STRING([--with-tests], [with tests @<:@default=no@:>@])],
  [AS_IF([test -z "$QUVI"], [
    AC_MSG_NOTICE([quvi not found. Ignoring --with-tests.])
    with_tests=no])],
  [with_tests=no])
AM_CONDITIONAL([WITH_TESTS], [test x"$with_tests" != "xno"])

# --with-nsfw
AC_ARG_WITH([nsfw],
  [AS_HELP_STRING([--with-nsfw],
    [build with adult website support @<:@default=no@:>@])],
  [],
  [with_nsfw=no])
AM_CONDITIONAL([WITH_NSFW], [test x"$with_nsfw" != "xno"])

# --with-fixme
AC_ARG_WITH([fixme],
  [AS_HELP_STRING([--with-fixme],
    [with website scripts marked as "fixme" @<:@default=no@:>@])],
  [],
  [with_fixme=no])
AM_CONDITIONAL([WITH_FIXME], [test x"$with_fixme" != "xno"])

# --with-nlfy
AC_ARG_WITH([nlfy],
  [AS_HELP_STRING([--with-nlfy],
    [test scripts marked as "nlfy" @<:@default=no@:>@])],
  [],
  [with_nlfy=no])
AM_CONDITIONAL([WITH_NLFY], [test x"$with_nlfy" != "xno"])

# --with-manual
AC_ARG_WITH([manual],
  [AS_HELP_STRING([--with-manual],
    [install manual pages @<:@default=yes@:>@])],
  [],
  [with_manual=yes])
AM_CONDITIONAL([WITH_MANUAL], [test x"$with_manual" != "xno"])

AC_CONFIG_FILES([
  Makefile
  doc/Makefile
  doc/man7/Makefile
  share/Makefile
  share/lua/Makefile
  tests/Makefile
  libquvi-scripts.pc])
AC_OUTPUT

AC_MSG_NOTICE([
  version:    ${VERSION} (${VN})
  prefix:     ${prefix}
quvi:
  version:    ${quviver}
  path:       ${QUVI}
Options:
  with tests: ${with_tests}
  with fixme: ${with_fixme}
  with nsfw:  ${with_nsfw}
  with nlfy:  ${with_nlfy}])
