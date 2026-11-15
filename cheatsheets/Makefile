SHEETS = distributions beginner intermediate advanced flatppl-cheatsheets
PDFS = $(SHEETS:%=%.pdf)
MODELS = $(wildcard examples/*.flatppl)
BRANDING = ../branding/logo-rounded.svg

.PHONY: all
all: $(PDFS)

%.pdf: %.typ theme.typ $(MODELS) $(BRANDING) distributions.typ beginner.typ intermediate.typ advanced.typ
	typst compile --root .. $< $@

flatppl-cheatsheets.pdf: flatppl-cheatsheets.typ theme.typ $(MODELS) $(BRANDING) distributions.typ beginner.typ intermediate.typ advanced.typ
	typst compile --root .. --input collection=true $< $@
