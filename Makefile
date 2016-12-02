DAPPER_ENV	?=
DAPPER_ARGS	?=
DAPPER_RUN	= env $(DAPPER_ENV) dapper -k -m bind $(DAPPER_ARGS)
PUBLISH_URL	= downloads.storageos.com:/var/www/html/docs

all: clean build

clean:
	rm -rf ./_site || true

serve:
	$(DAPPER_RUN) serve

build:
	$(DAPPER_RUN) build

publish: build
	(cd ./_site && \
	chmod -R g+w . && \
	rsync -avP --delete --omit-dir-times . $(PUBLISH_URL))
