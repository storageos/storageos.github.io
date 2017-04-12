DAPPER_ENV	?=
DAPPER_ARGS	?=
DAPPER_RUN	= env $(DAPPER_ENV) dapper -k -m bind $(DAPPER_ARGS)

all: clean build

clean:
	rm -rf ./_site || true

serve:
	$(DAPPER_RUN) serve

build:
	$(DAPPER_RUN) build
