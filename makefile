TEX_FILES := $(wildcard */main.tex) $(wildcard */proposal/main.tex)
PDF_FILES := $(patsubst %.tex, %.pdf, $(TEX_FILES))
TEX_FOLDERS := $(dir $(TEX_FILES))
INTERMEDIATES := *.out *.aux *.log *.synctex.gz *.bbl *.blg *.nlo
FIG_INTERMEDIATES := *-eps-converted-to.pdf **/*-eps-converted-to.pdf

.PHONY: mostlyclean

# By default, make all files and then clean up
default: all mostlyclean

# Generate PDFs, leaving any intermediate files
all: $(PDF_FILES)

# Generate PDF for a given TeX file
%.pdf: %.tex
	if ls $(@D)/*.bib 1> /dev/null 2>&1; then cd $(@D) && pdflatex $(<F); fi;
	if ls $(@D)/*.bib 1> /dev/null 2>&1; then cd $(@D) && bibtex $(*F); fi;
	cd $(@D) && pdflatex $(<F)
	cd $(@D) && pdflatex $(<F)
	
# Remove all TeX intermediates
mostlyclean:
	$(RM) $(foreach dir, $(TEX_FOLDERS), $(foreach int, $(INTERMEDIATES), $(dir)$(int)))

# Remove TeX intermediates and figure intermediates
clean: mostlyclean
	$(RM) $(foreach dir, $(TEX_FOLDERS), $(foreach int, $(FIG_INTERMEDIATES), $(dir)$(int)))

# Remove all intermediates and final PDFs
distclean: clean
	$(RM) $(PDF_FILES)