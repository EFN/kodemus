
TARGETS = kodemus.pdf kodemus.epub kodemus.txt kodemus.html kodemus.mobi

all: lint $(TARGETS)

XMLLINTOPTS = --nonet --noout  --xinclude --postvalid
lint: kodemus.xml
	xmllint $(XMLLINTOPTS) $<

%.pdf: %.xml
	if false ; then \
		dblatex -T simple -P latex.class.options=a4paper $< ; \
	else \
		xsltproc --output tmp.fo \
		  stylesheet-fo.xsl \
		  $< ; \
		fop -fo tmp.fo -pdf $@ ; \
	fi

%.epub: %.xml
	dbtoepub -s stylesheet-epub.xsl $<
%.txt: %.xml
	xmlto -x stylesheet-html.xsl txt $<
%.html: %.xml
	xmlto -x stylesheet-html.xsl html-nochunks $<
%.mobi: %.epub
	ebook-convert $< $@

clean:
	$(RM) tmp.fo *~
distclean: clean
	$(RM) $(TARGETS)
