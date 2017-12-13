# -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

# Initializations
AC_INIT([mcsim], [5.6.6], [bug-mcsim@gnu.org])

AC_PREREQ(2.68)                   # requires at least autoconf v...
AC_CONFIG_SRCDIR([mod/mod.c])     # safety check for configure run */
AC_CONFIG_MACRO_DIR([m4])
AM_INIT_AUTOMAKE([-Wall -Werror])
AM_PROG_AR
LT_INIT                           # init libtool

# Checks for general programs.
AC_PROG_CC

# Checks for programs needed by xmcsim
AC_CHECK_PROG(WISH_FOUND,wish,yes)
AC_CHECK_PROG(PLOT_FOUND,gnuplot,yes)

# Checks for libraries; watch the order between cblas and gsl
AC_CHECK_LIB([gslcblas], [main])
AC_CHECK_LIB([gsl], [gsl_cdf_gamma_P])
AC_CHECK_LIB([m], [main])
AC_CHECK_LIB([sbml], [main])

# Checks for header files.
AC_HEADER_STDC
AC_CHECK_HEADERS([float.h limits.h])

# Checks for typedefs, structures, and compiler characteristics.
AC_C_CONST
AC_STRUCT_TM

# Checks for library functions.
AC_FUNC_MALLOC
AC_FUNC_REALLOC
AC_CHECK_FUNCS([floor modf pow sqrt strchr])

# Output files
AC_CONFIG_HEADERS([config.h])
AC_CONFIG_FILES([Makefile
                 mod/Makefile
                 sim/Makefile
                 sim/makemcsim
                 sim/makemcsimd
                 sim/makemcsims])

AC_CONFIG_FILES([examples/perc/Makefile], [chmod +x examples/perc/Makefile])

AC_OUTPUT

