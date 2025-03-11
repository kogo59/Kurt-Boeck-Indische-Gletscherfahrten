BUILD = build
MAKEFILE = Makefile
OUTPUT_FILENAME = "Indische_Gletscherfahrten_Dr_Kurt_Boeck"
TITLE_NAME = "Indische Gletscherfahrten"
METADATA = metadata.yml
CHAPTERS = chapters/*.md
TOC = --toc --toc-depth=2
IMAGES_FOLDER = images
IMAGES = $(IMAGES_FOLDER)/*
COVER_IMAGE = $(IMAGES_FOLDER)/cover.jpg
LATEX_CLASS = book
MATH_FORMULAS = --webtex
CSS_FILE = blitz.css
CSS_FILE_KINDLE=blitz.css
CSS_FILE_PRINT=print.css
CSS_ARG = --css=$(CSS_FILE)
CSS_ARG_KINDLE = --css=$(CSS_FILE_KINDLE)
CSS_ARG_PRINT = --css=$(CSS_FILE_PRINT)
METADATA_ARG = --metadata-file=$(METADATA)
METADATA_PDF = chapters/preface/metadata_pdf_html.md
PREFACE_EPUB = chapters/preface/preface_epub.md chapters/preface/preface_epub.md
PREFACE_HTML_PDF = chapters/preface/preface_html_pdf.md
ARGS = $(TOC) $(MATH_FORMULAS) $(CSS_ARG) $(METADATA_ARG) --reference-location=section
ARGS_HTML = $(TOC) $(MATH_FORMULAS) $(CSS_ARG) --reference-location=section --metadata=lang:de $(METADATA_PDF)
#CALIBRE="../../calibre/Calibre Portable/Calibre/"
#CALIBRE = "C:/Program Files/Calibre2/"
CALIBRE=""
PANDOC = "pandoc"

all: book

book: epub html pdf docx

clean:
	rm -r $(BUILD)

epub: $(BUILD)/epub/$(OUTPUT_FILENAME).epub

pdf: $(BUILD)/pdf/$(OUTPUT_FILENAME).pdf

$(BUILD)/epub/$(OUTPUT_FILENAME).epub: $(MAKEFILE) $(METADATA) $(CHAPTERS) $(CSS_FILE) $(CSS_FILE_KINDLE) $(IMAGES) \
																			 $(COVER_IMAGE) $(METADATA) $(PREFACE_EPUB)
	mkdir -p $(BUILD)/epub
	$(PANDOC) $(ARGS) --from markdown+raw_html+fenced_divs+fenced_code_attributes+bracketed_spans --to epub+raw_html --resource-path=$(IMAGES_FOLDER) --epub-cover-image=$(COVER_IMAGE) -o $@  $(PREFACE_EPUB) $(CHAPTERS)

	$(CALIBRE)ebook-polish --add-soft-hyphens -i -p -U  $@ $@
	$(CALIBRE)ebook-convert $@ $(BUILD)/epub/$(OUTPUT_FILENAME).azw3 --share-not-sync --disable-font-rescaling
	$(CALIBRE)ebook-convert $(BUILD)/epub/$(OUTPUT_FILENAME).azw3 $(BUILD)/epub/$(OUTPUT_FILENAME).mobi --share-not-sync --disable-font-rescaling --mobi-file-type both

docx: $(BUILD)/docx/$(OUTPUT_FILENAME).docx

$(BUILD)/docx/$(OUTPUT_FILENAME).docx: $(MAKEFILE) $(METADATA) $(CHAPTERS) $(CSS_FILE) $(CSS_FILE_KINDLE) $(IMAGES) \
																			 $(COVER_IMAGE) $(PREFACE_HTML_PDF)
	mkdir -p $(BUILD)/docx
	$(PANDOC) $(ARGS_HTML) --from markdown+raw_html+fenced_divs+fenced_code_attributes+bracketed_spans --to docx --resource-path=$(IMAGES_FOLDER) -o $@ $(METADATA_PDF) $(PREFACE_HTML_PDF) $(CHAPTERS)

html: $(BUILD)/html/$(OUTPUT_FILENAME).html

$(BUILD)/html/$(OUTPUT_FILENAME).html: $(MAKEFILE) $(METADATA_PDF) $(CHAPTERS_HTML_PDF) $(CSS_FILE) $(IMAGES) $(COVER_IMAGE)  $(PREFACE_HTML_PDF)
	mkdir -p $(BUILD)/html
	cp  *.css  $(IMAGES_FOLDER)
	pandoc $(ARGS_HTML) --embed-resources --standalone --resource-path=$(IMAGES_FOLDER) --from markdown+pandoc_title_block+raw_html+fenced_divs+fenced_code_attributes+bracketed_spans+yaml_metadata_block --to=html5 -o $@  $(PREFACE_HTML_PDF) $(CHAPTERS)
	rm  $(IMAGES_FOLDER)/*.css

pdf: $(BUILD)/pdf/$(OUTPUT_FILENAME).pdf

$(BUILD)/pdf/$(OUTPUT_FILENAME).pdf: $(MAKEFILE) $(METADATA_PDF) $(CHAPTERS_HTML_PDF) $(CSS_FILE) $(IMAGES) $(COVER_IMAGE) $(METADATA_PDF) $(PREFACE_EPUB)
	mkdir -p $(BUILD)/pdf
	cp  *.css  $(IMAGES_FOLDER)
	cp  $(IMAGES_FOLDER)/Indische_Gletscherfahrten_*.jpg .
	cp  $(IMAGES_FOLDER)/cover.jpg .	
	cp  $(IMAGES_FOLDER)/logo.jpg .
	pandoc $(ARGS_HTML) $(CSS_ARG_PRINT) --pdf-engine=prince --resource-path=$(IMAGES_FOLDER) --from markdown+pandoc_title_block+raw_html+fenced_divs+fenced_code_attributes+bracketed_spans+yaml_metadata_block --to=html5 -o $@ $(PREFACE_HTML_PDF) $(CHAPTERS)
	rm  $(IMAGES_FOLDER)/*.css
	rm Indische_Gletscherfahrten_*.jpg
	rm cover.jpg logo.jpg


