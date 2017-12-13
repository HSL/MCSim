SUBDIRS = mod sim

ACLOCAL_AMFLAGS = -I m4

TESTS = examples/perc/Makefile

include_HEADERS = config.h

EXTRA_DIST = examples xmcsim doc

dist-hook:
	rm -rf `find $(distdir)/examples -name CVS`
	rm -rf `find $(distdir)/xmcsim -name CVS`
	rm -rf `find $(distdir)/doc -name CVS`
