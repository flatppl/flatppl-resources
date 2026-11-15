SHEETS = distributions beginner intermediate advanced flatppl-cheatsheets
PDFS = $(SHEETS:%=%.pdf)
MODELS = $(wildcard examples/*.flatppl)
BRANDING = ../branding/logo-rounded.svg
SYNTAX = $(wildcard syntax/*.sublime-syntax syntax/*.tmTheme)

.PHONY: all
all: $(PDFS)

%.pdf: %.typ theme.typ $(MODELS) $(BRANDING) $(SYNTAX) distributions.typ beginner.typ intermediate.typ advanced.typ
	typst compile --root .. $< $@

flatppl-cheatsheets.pdf: flatppl-cheatsheets.typ theme.typ $(MODELS) $(BRANDING) $(SYNTAX) distributions.typ beginner.typ intermediate.typ advanced.typ
	typst compile --root .. --input collection=true $< $@
