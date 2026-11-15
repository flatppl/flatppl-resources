SHEETS = distributions beginner intermediate advanced particle-physics hadron-physics neutrino-physics
PDFS = $(SHEETS:%=%.pdf) flatppl-cheatsheets.pdf
SOURCES = $(SHEETS:%=%.typ)
MODELS = $(wildcard examples/*.flatppl)
BRANDING = ../branding/logo-rounded.svg
SYNTAX = $(wildcard syntax/*.sublime-syntax syntax/*.tmTheme)

.PHONY: all
all: $(PDFS)

%.pdf: %.typ theme.typ $(MODELS) $(BRANDING) $(SYNTAX) $(SOURCES)
	typst compile --root .. $< $@

flatppl-cheatsheets.pdf: flatppl-cheatsheets.typ theme.typ $(MODELS) $(BRANDING) $(SYNTAX) $(SOURCES)
	typst compile --root .. --input collection=true $< $@
