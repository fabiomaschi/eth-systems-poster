# LaTeX Makefile using latexmk
# Modified by Dogukan Cagatay <dcagatay@gmail.com>
# Originally from : http://tex.stackexchange.com/a/40759
#
PROJNAME = poster
DIR_TMP = build

# Include non-file targets in .PHONY so they are run regardless of any file of
# the given name existing
.PHONY: $(PROJNAME).pdf all clean

all: $(PROJNAME).pdf

# CUSTOM BUILD RULES

# In case you didn't know, '$@' is a variable holding the name of the target,
# and '$<' is a variable holding the (first) dependency of a rule.
# "raw2tex" and "dat2tex" are just placeholders for whatever custom steps
# you might have.

%.tex: %.raw
		./raw2tex $< > $@

%.tex: %.dat
		./dat2tex $< > $@

# MAIN LATEXMK RULE

# -pdf tells latexmk to generate PDF directly (instead of DVI).
# -pdflatex="" tells latexmk to call a specific backend with specific options.
# -use-make tells latexmk to call make for generating missing files.

# -interaction=nonstopmode keeps the pdflatex backend from stopping at a
# missing file reference and interactively asking you for an alternative.

$(PROJNAME).pdf: $(PROJNAME).tex
		latexmk -quiet -bibtex \
				-halt-on-error -outdir=$(DIR_TMP) -auxdir=$(DIR_TMP) \
				-f -pdf -pdflatex="pdflatex -interaction=nonstopmode" \
				-use-make $(PROJNAME).tex
		mv $(DIR_TMP)/$(PROJNAME).pdf ./$(PROJNAME).pdf
		evince $(PROJNAME).pdf&

debug: $(PROJNAME).tex
		latexmk -bibtex \
				-halt-on-error -outdir=$(DIR_TMP) -auxdir=$(DIR_TMP) \
				-f -pdf -pdflatex="pdflatex -interaction=nonstopmode" \
				-use-make $(PROJNAME).tex
		mv $(DIR_TMP)/$(PROJNAME).pdf ./$(PROJNAME).pdf
		evince $(PROJNAME).pdf&

cleanall:
		latexmk -bibtex -outdir=$(DIR_TMP) -auxdir=$(DIR_TMP) -C

clean:
		latexmk -bibtex -outdir=$(DIR_TMP) -auxdir=$(DIR_TMP) -c