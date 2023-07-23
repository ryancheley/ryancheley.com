PY?=python3
PELICAN?=pelican
PELICANOPTS=

BASEDIR=$(CURDIR)
INPUTDIR=$(BASEDIR)/content
OUTPUTDIR=$(BASEDIR)/output
CONFFILE=$(BASEDIR)/pelicanconf.py
PUBLISHCONF=$(BASEDIR)/publishconf.py


DEBUG ?= 0
ifeq ($(DEBUG), 1)
	PELICANOPTS += -D
endif

RELATIVE ?= 0
ifeq ($(RELATIVE), 1)
	PELICANOPTS += --relative-urls
endif

SERVER ?= "0.0.0.0"

PORT ?= 0
ifneq ($(PORT), 0)
	PELICANOPTS += -p $(PORT)
endif


help:
	@echo 'Makefile for a pelican Web site                                           '
	@echo '                                                                          '
	@echo 'Usage:                                                                    '
	@echo '   make html                           (re)generate the web site          '
	@echo '   make clean                          remove the generated files         '
	@echo '   make regenerate                     regenerate files upon modification '
	@echo '   make publish                        generate using production settings '
	@echo '   make serve [PORT=8000]              serve site at http://localhost:8000'
	@echo '   make serve-global [SERVER=0.0.0.0]  serve (as root) to $(SERVER):80    '
	@echo '   make devserver [PORT=8000]          serve and regenerate together      '
	@echo '   make devserver-global               regenerate and serve on 0.0.0.0    '
	@echo '                                                                          '
	@echo 'Set the DEBUG variable to 1 to enable debugging, e.g. make DEBUG=1 html   '
	@echo 'Set the RELATIVE variable to 1 to enable relative urls                    '
	@echo '                                                                          '

html:
	"$(PELICAN)" "$(INPUTDIR)" -o "$(OUTPUTDIR)" -s "$(CONFFILE)" $(PELICANOPTS)

clean:
	[ ! -d "$(OUTPUTDIR)" ] || rm -rf "$(OUTPUTDIR)"

regenerate:
	"$(PELICAN)" -r "$(INPUTDIR)" -o "$(OUTPUTDIR)" -s "$(CONFFILE)" $(PELICANOPTS)

serve:
	"$(PELICAN)" -l "$(INPUTDIR)" -o "$(OUTPUTDIR)" -s "$(CONFFILE)" $(PELICANOPTS)

serve-global:
	"$(PELICAN)" -l "$(INPUTDIR)" -o "$(OUTPUTDIR)" -s "$(CONFFILE)" $(PELICANOPTS) -b $(SERVER)

devserver:
	"$(PELICAN)" -lr "$(INPUTDIR)" -o "$(OUTPUTDIR)" -s "$(CONFFILE)" $(PELICANOPTS)

devserver-global:
	$(PELICAN) -lr $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) $(PELICANOPTS) -b 0.0.0.0

publish:
	"$(PELICAN)" "$(INPUTDIR)" -o "$(OUTPUTDIR)" -s "$(PUBLISHCONF)" $(PELICANOPTS)

vercel:
	{ \
	echo "Generate content and database"; \
	make html; \
	echo "Content generation complete"; \
	echo "Publish data to vercel"; \
	datasette publish vercel pelican.db --project=search-ryancheley --metadata metadata.json; \
	echo "Publishing complete"; \
	}

tweet:
	./tweet.sh

newpost:
	touch content/$$(echo $${category})/$$(echo $${title} | sed -e 's/[^[:alnum:]]/-/g' | tr -s '-' | tr A-Z a-z.md).md
	echo "Title: $${title}" > content/$$(echo $${category})/$$(echo $${title} | sed -e 's/[^[:alnum:]]/-/g' | tr -s '-' | tr A-Z a-z.md).md
	echo "Date: $$(date +%F)" >> content/$$(echo $${category})/$$(echo $${title} | sed -e 's/[^[:alnum:]]/-/g' | tr -s '-' | tr A-Z a-z.md).md
	echo "Author: ryan" >> content/$$(echo $${category})/$$(echo $${title} | sed -e 's/[^[:alnum:]]/-/g' | tr -s '-' | tr A-Z a-z.md).md
	echo "Tags: " >> content/$$(echo $${category})/$$(echo $${title} | sed -e 's/[^[:alnum:]]/-/g' | tr -s '-' | tr A-Z a-z.md).md
	printf "Slug: " >> content/$$(echo $${category})/$$(echo $${title} | sed -e 's/[^[:alnum:]]/-/g' | tr -s '-' | tr A-Z a-z.md).md
	echo "$${title}" | sed -e 's/[^[:alnum:]]/-/g' | tr -s '-' | tr A-Z a-z >> content/$$(echo $${category})/$$(echo $${title} | sed -e 's/[^[:alnum:]]/-/g' | tr -s '-' | tr A-Z a-z.md).md
	echo "Series: Remove if Not Needed"  >> content/$$(echo $${category})/$$(echo $${title} | sed -e 's/[^[:alnum:]]/-/g' | tr -s '-' | tr A-Z a-z.md).md
	echo "Status: draft"  >> content/$$(echo $${category})/$$(echo $${title} | sed -e 's/[^[:alnum:]]/-/g' | tr -s '-' | tr A-Z a-z.md).md

reqs:
	pip-compile
	pip install -r requirements.txt

draft:
	./find_draft_status.sh

.PHONY: html help clean regenerate serve serve-global devserver publish vercel tweet reqs
