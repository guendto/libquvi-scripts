#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.67])

m4_include([m4/version.m4])

AC_INIT([libquvi-scripts], [libquvi_scripts_rel],
        [http://quvi.sf.net/bugs/], [], [http://quvi.sf.net/])

AC_CONFIG_SRCDIR([tests/lib/env.c])
AC_CONFIG_HEADERS([config.h])
AC_CONFIG_AUX_DIR([config.aux])
AC_CONFIG_MACRO_DIR([m4])

AM_INIT_AUTOMAKE([1.11.1 -Wall -Werror dist-xz no-dist-gzip tar-ustar])
AM_SILENT_RULES([yes])
#AM_PROG_AR

LT_INIT([disable-static])
LT_PREREQ([2.2.6])

# Checks for programs.
AC_PROG_CC
AM_PROG_CC_C_O
AC_PROG_LN_S

# Version.
VN_RMAJ=libquvi_scripts_rmaj
VN_RMIN=libquvi_scripts_rmin
VN_RMIC=libquvi_scripts_rmic
AC_SUBST([VN_RMAJ])
AC_SUBST([VN_RMIN])
AC_SUBST([VN_RMIC])

VERSION_MM="$VN_RMAJ.$VN_RMIN"
AC_SUBST([VERSION_MM])

genver="$srcdir/gen-ver.sh"
AS_IF([test -x "$genver"], [VN=`"$genver" "$srcdir"`])
AM_CONDITIONAL([HAVE_VN], [test -n "$VN"])

# --with-tests
pkg_libquvi=libquvi-1.0
AC_ARG_WITH([tests],
  [AS_HELP_STRING([--with-tests],
    [Enable tests for scripts @<:@default=no@:>@])],
  [PKG_CHECK_MODULES([libquvi], ["$pkg_libquvi" >= 1.0],
    [libquvi_modver=`$PKG_CONFIG --modversion $pkg_libquvi 2>/dev/null`
      PKG_CHECK_MODULES([glib], [glib-2.0 >= 2.24],
      [PKG_CHECK_MODULES([libcurl], [libcurl >= 7.21], [with_tests=yes])])
    ])
  ], [with_tests=no])
AM_CONDITIONAL([WITH_TESTS], [test x"$with_tests" = "xyes"])

# --with-nsfw
AC_ARG_WITH([nsfw],
  [AS_HELP_STRING([--with-nsfw],
    [Install scripts marked as "NSFW" @<:@default=no@:>@])],
  [], [with_nsfw=no])
AM_CONDITIONAL([WITH_NSFW], [test x"$with_nsfw" != "xno"])

# --with-fixme
AC_ARG_WITH([fixme],
  [AS_HELP_STRING([--with-fixme],
    [Install scripts marked as "FIXME" @<:@default=no@:>@])],
  [], [with_fixme=no])
AM_CONDITIONAL([WITH_FIXME], [test x"$with_fixme" != "xno"])

# --with-geoblocked
AC_ARG_WITH([geoblocked],
  [AS_HELP_STRING([--with-geoblocked],
    [Install scripts marked as "geoblocked" @<:@default=yes@:>@])],
  [], [with_geoblocked=yes])
AM_CONDITIONAL([WITH_GEOBLOCKED], [test x"$with_geoblocked" = "xyes"])

# --with-manual
AC_ARG_WITH([manual],
  [AS_HELP_STRING([--with-manual],
    [Install manual page(s) @<:@default=yes@:>@])],
  [], [with_manual=yes])
AM_CONDITIONAL([WITH_MANUAL], [test x"$with_manual" != "xno"])

AC_CONFIG_FILES([
  Makefile
  doc/Makefile
  doc/man7/Makefile
  share/Makefile
  tests/Makefile
  tests/lib/Makefile
  libquvi-scripts-1.0.pc])
AC_OUTPUT

AC_MSG_NOTICE([
  version:    ${VERSION} (${VN})
  prefix:     ${prefix}
  compiler    ${CC}
  cflags      ${CFLAGS}
Testsuite options:
  with:
  - tests: ${with_tests} (libquvi, .pc modversion ${libquvi_modver})
Install options:
  with:
  - geoblocked:  ${with_geoblocked}
  - fixme:       ${with_fixme}
  - nsfw:        ${with_nsfw}])
