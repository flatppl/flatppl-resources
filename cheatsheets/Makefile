SHEETS = distributions beginner intermediate advanced particle-physics hadron-physics neutrino-physics
PDFS = $(SHEETS:%=%.pdf) flatppl-cheatsheets.pdf
SOURCES = $(SHEETS:%=%.typ)
MODELS = $(wildcard examples/*.flatppl)
BRANDING = ../branding/logo-rounded.svg
SYNTAX = $(wildcard syntax/*.sublime-syntax syntax/*.tmTheme)
FIGURES = $(SHEETS:%=figures/%.svg)
COMMON = theme.typ $(BRANDING) $(SYNTAX)

.PHONY: all
all: $(PDFS)

%.pdf: %.typ examples/%.flatppl figures/%.svg $(COMMON)
	typst compile --root .. $< $@

flatppl-cheatsheets.pdf: flatppl-cheatsheets.typ $(COMMON) $(MODELS) $(SOURCES) $(FIGURES)
	typst compile --root .. --input collection=true $< $@
