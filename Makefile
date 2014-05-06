# contrib/fhir_jsonb/Makefile

MODULE_big = fhir_jsonb

EXTENSION = fhir_jsonb
DATA = fhir_jsonb--1.0.sql

REGRESS = fhir_jsonb


ifdef USE_PGXS
PG_CONFIG = pg_config
PGXS := $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)
else
subdir = contrib/fhir_jsonb
top_builddir = ../..
include $(top_builddir)/src/Makefile.global
include $(top_srcdir)/contrib/contrib-global.mk
endif
