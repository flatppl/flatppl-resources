SHEETS := $(shell cat sheets.txt)
PDFS = $(SHEETS:%=%.pdf) flatppl-cheatsheets.pdf
SOURCES = $(SHEETS:%=%.typ)
MODELS = $(wildcard examples/*.flatppl)
BRANDING = ../branding/logo-rounded.svg
SYNTAX = $(wildcard syntax/*.sublime-syntax syntax/*.tmTheme)
FIGURES = $(SHEETS:%=figures/%.svg)
COMMON = theme.typ sheets.txt $(BRANDING) $(SYNTAX)
FLATPPL ?= flatppl
IMPORT_MODELS = examples/decay-ode.flatppl examples/profile-marginal.flatppl

.PHONY: all
all: $(PDFS)

.PHONY: check-examples
check-examples:
	$(FLATPPL) lint --allow not-canonical --deny-warnings $(filter-out $(IMPORT_MODELS),$(MODELS))
	@# The standalone linter has no module resolver. Check imported names in infer below.
	$(FLATPPL) lint --allow not-canonical --allow unresolved-name --deny-warnings $(IMPORT_MODELS)
	@set -e; scratch=$$(mktemp -d); trap 'rm -f "$$scratch/check.flatpir"; rmdir "$$scratch"' EXIT; \
	for model in $(MODELS); do $(FLATPPL) infer --no-header "$$model" "$$scratch/check.flatpir"; done

%.pdf: %.typ examples/%.flatppl figures/%.svg $(COMMON)
	typst compile --root .. $< $@

fitting-from-python.pdf flatppl-cheatsheets.pdf: examples/fit.py

flatppl-cheatsheets.pdf: flatppl-cheatsheets.typ $(COMMON) $(MODELS) $(SOURCES) $(FIGURES)
	typst compile --root .. --input collection=true $< $@
