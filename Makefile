BUILD = build
MAKEFILE = Makefile
OUTPUT_FILENAME = Indische_Gletscherfahrten
TITLE_NAME = "Indische Gletscherfahrten"
METADATA = metadata.yml
CHAPTERS = chapters/*.md
TOC = --toc --toc-depth=2
IMAGES_FOLDER = images
IMAGES = $(IMAGES_FOLDER)/*
COVER_IMAGE = $(IMAGES_FOLDER)/cover.jpg
LATEX_CLASS = book
MATH_FORMULAS = --webtex
CSS_FILE = blitz_kg.css
CSS_FILE_KINDLE=blitz-kindle.css
CSS_FILE_PRINT=print.css
CSS_ARG = --css=$(CSS_FILE)
CSS_ARG_KINDLE = --css=$(CSS_FILE_KINDLE)
CSS_ARG_PRINT = --css=$(CSS_FILE_PRINT)
METADATA_ARG = --metadata-file=$(METADATA)
METADATA_PDF = chapters/preface/metadata_pdf_html.md
PREFACE_EPUB = chapters/preface/preface_epub.md
PREFACE_HTML_PDF = chapters/preface/preface_html_pdf.md
ARGS = $(TOC) $(MATH_FORMULAS) $(CSS_ARG) $(CSS_ARG_KINDLE) $(METADATA_ARG)
#CALIBRE="../../calibre/Calibre Portable/Calibre/"
CALIBRE=""

all: book

book: epub html pdf docx

clean:
	rm -r $(BUILD)

epub: $(BUILD)/epub/$(OUTPUT_FILENAME).epub

html: $(BUILD)/html/$(OUTPUT_FILENAME).html

pdf: $(BUILD)/pdf/$(OUTPUT_FILENAME).pdf

docx: $(BUILD)/docx/$(OUTPUT_FILENAME).docx

$(BUILD)/epub/$(OUTPUT_FILENAME).epub: $(MAKEFILE) $(METADATA) $(CHAPTERS) $(CSS_FILE) $(CSS_FILE_KINDLE) $(IMAGES) \
																			 $(COVER_IMAGE) $(METADATA) $(PREFACE_EPUB)
	mkdir -p $(BUILD)/epub
	pandoc $(ARGS) --from markdown+raw_html+fenced_divs+fenced_code_attributes+bracketed_spans --to epub+raw_html --resource-path=$(IMAGES_FOLDER) --epub-cover-image=$(COVER_IMAGE) -o $@  $(PREFACE_EPUB) $(CHAPTERS)
#	@echo
#	@echo Ueberpruefung starten
#	@echo Doppelte IDs von allen Elementen ausser dem ersten entfernen
#	@echo speichern
#	@echo
#	$(CALIBRE)ebook-edit $@
#	$(CALIBRE)ebook-polish -i -p -U $@ $@
#	$(CALIBRE)ebook-convert $@ $(BUILD)/epub/$(OUTPUT_FILENAME).azw3 --share-not-sync
#	$(eval IDENT=$(shell $(CALIBRE)calibredb search $(TITLE_NAME)))
#	$(eval BID=$(strip $(IDENT)))
#	if [ $(BID) != "" ]; then \
#		$(CALIBRE)calibredb remove $(BID); \
#	fi
#	@echo
#	@echo Hyphenate This! fuer azw3 durchfuehren
#	@echo
#	$(CALIBRE)calibre $(BUILD)/epub/$(OUTPUT_FILENAME).azw3
#	$(eval IDENT=$(shell $(CALIBRE)calibredb search  $(TITLE_NAME)))
#	$(eval BIDA=`expr $(IDENT) + 1`;)
#	$(CALIBRE)calibredb export --single-dir --to-dir $(BUILD)/epub --formats azw3 $(BIDA)
#	$(CALIBRE)calibredb remove $(BIDA)
#	rm $(BUILD)/epub/$(OUTPUT_FILENAME).azw3

$(BUILD)/html/$(OUTPUT_FILENAME).html: $(MAKEFILE) $(METADATA) $(CHAPTERS) $(CSS_FILE) $(CSS_FILE_KINDLE) $(IMAGES) $(COVER_IMAGE) $(METADATA_PDF)
	mkdir -p $(BUILD)/html
	cp  *.css  $(IMAGES_FOLDER)
	pandoc $(ARGS) --self-contained --standalone --resource-path=$(IMAGES_FOLDER) --from markdown+pandoc_title_block+raw_html+fenced_divs+fenced_code_attributes+bracketed_spans+yaml_metadata_block --to=html5 -o $@ $(METADATA_PDF) $(PREFACE_HTML_PDF) $(CHAPTERS)
	rm  $(IMAGES_FOLDER)/*.css

$(BUILD)/pdf/$(OUTPUT_FILENAME).pdf: $(MAKEFILE) $(METADATA) $(CHAPTERS) $(CSS_FILE) $(CSS_FILE_KINDLE) $(CSS_FILE_PRINT) $(IMAGES) $(COVER_IMAGE) $(METADATA_PDF) $(PREFACE_HTML_PDF)
	mkdir -p $(BUILD)/pdf
	cp  $(IMAGES_FOLDER)/*.jpg .
	cp  $(IMAGES_FOLDER)/*.png .
	pandoc $(ARGS) $(CSS_ARG_PRINT) --self-contained --standalone --pdf-engine=weasyprint --resource-path=$(IMAGES_FOLDER) --from markdown+yaml_metadata_block+raw_html+fenced_divs+fenced_code_attributes+bracketed_spans  --to=html5  -o $@  $(METADATA_PDF) $(PREFACE_HTML_PDF) $(CHAPTERS)
	rm *.jpg
	rm *.png

$(BUILD)/docx/$(OUTPUT_FILENAME).docx: $(MAKEFILE) $(METADATA) $(CHAPTERS) $(CSS_FILE) $(CSS_FILE_KINDLE) $(IMAGES) \
																			 $(COVER_IMAGE) $(PREFACE_HTML_PDF)
	mkdir -p $(BUILD)/docx
	pandoc $(ARGS) --from markdown+raw_html+fenced_divs+fenced_code_attributes+bracketed_spans --to docx --resource-path=$(IMAGES_FOLDER) -o $@  $(CHAPTERS)