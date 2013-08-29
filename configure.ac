#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.69])

AC_INIT([libquvi-scripts], m4_esyscmd([./gen-ver.sh -c | tr -d '\n']),
        [http://quvi.sf.net/bugs/],[],[http://quvi.sf.net/])

BUILD_OPTS="$@"
AC_SUBST([BUILD_OPTS])

AC_CONFIG_SRCDIR([tests/lib/env.c])
AC_CONFIG_HEADERS([config.h])
AC_CONFIG_AUX_DIR([config.aux])
AC_CONFIG_MACRO_DIR([m4])

AM_INIT_AUTOMAKE([1.11.1 -Wall -Werror dist-xz no-dist-gzip
                  tar-ustar subdir-objects])
AM_SILENT_RULES([yes])

# GNU Automake 1.12 requires this macro. Earlier versions do not
# recognize this macro. Work around this.
m4_ifdef([AM_PROG_AR], [AM_PROG_AR])

LT_INIT([disable-static])
LT_PREREQ([2.2.6])

# Checks for programs.
AC_PROG_CC
AM_PROG_CC_C_O
AC_PROG_LN_S

AC_PATH_PROG([A2X], [a2x], [no])
AM_CONDITIONAL([HAVE_A2X], [test x"$A2X" != "xno"])
AC_SUBST([A2X])

AS_IF([test x"$A2X" = "xno" && test -d "$srcdir/.git"],
  AC_MSG_ERROR([a2x is required to create man pages when building from git])])

# Check for headers.
AC_CHECK_HEADERS([string.h])

# Check for functions.
AC_CHECK_FUNCS([memset])

# --with-tests
pkg_libquvi=libquvi-0.9
AC_ARG_WITH([tests],
  [AS_HELP_STRING([--with-tests],
    [Enable tests for scripts @<:@default=no@:>@])],
  [PKG_CHECK_MODULES([libquvi], ["$pkg_libquvi" >= 0.9],
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

# Version: Major/minor -pair, used to symlink
# from
#   $prefix/share/libquvi-scripts/$version/
# to
#   $prefix/share/libquvi-scripts/$major.$minor/
VERSION_MM=`$srcdir/gen-ver.sh -c -m`
AC_SUBST([VERSION_MM])

VN_C=`$srcdir/gen-ver.sh -c` # Use this value in the .pc file
AC_SUBST([VN_C])

AC_CONFIG_FILES([
  Makefile
  doc/Makefile
  doc/man7/Makefile
  share/Makefile
  tests/Makefile
  tests/lib/Makefile
  libquvi-scripts-0.9.pc])
AC_OUTPUT

AC_MSG_NOTICE([
  version       ${VERSION}
  prefix        ${prefix}
  compiler      ${CC}
  cflags        ${CFLAGS}
Testsuite options
  with
  - tests       ${with_tests}
    - libquvi .pc modversion ${libquvi_modver}
Install options
  with
  - geoblocked  ${with_geoblocked}
  - fixme       ${with_fixme}
  - nsfw        ${with_nsfw}])

# vim: set ts=2 sw=2 tw=72 expandtab:
