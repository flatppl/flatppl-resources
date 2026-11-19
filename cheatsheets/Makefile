SHEETS := $(shell cat sheets.txt)
BUILD := ../build/cheatsheets
PDFS := $(SHEETS:%=$(BUILD)/%.pdf)
MODELS = $(wildcard examples/*.flatppl)
BRANDING = ../branding/logo-rounded.svg
SYNTAX = $(wildcard syntax/*.sublime-syntax syntax/*.tmTheme)
MODEL_SHEETS = $(filter-out python-sdk cli formula-api,$(SHEETS))
FIGURE_SHEETS = $(filter-out advanced einstein-reductions,$(MODEL_SHEETS))
COMMON = theme.typ examples/LICENSE.txt examples/NOTICE.md $(BRANDING) $(SYNTAX) $(wildcard fonts/*.ttf)
FLATPPL ?= flatppl
IMPORT_MODELS = examples/decay-ode.flatppl examples/measurement.flatppl examples/profile-marginal.flatppl examples/three-flavour.flatppl

.PHONY: all
all: $(PDFS)

.PHONY: check-pdfs
check-pdfs: $(PDFS)
	@set -e; for pdf in $(PDFS); do \
		pages=$$(LC_ALL=C pdfinfo "$$pdf" | awk '/^Pages:/ {print $$2}'); \
		if [ "$$pages" != 1 ]; then echo "$$pdf: expected one page, found '$$pages'" >&2; exit 1; fi; \
	done
	@echo "Verified $(words $(PDFS)) one-page PDFs."

.PHONY: check-examples
check-examples:
	$(FLATPPL) prepare $(IMPORT_MODELS)
	$(FLATPPL) lint --allow not-canonical --deny-warnings $(filter-out $(IMPORT_MODELS),$(MODELS))
	@# The standalone linter has no module resolver. Check imported names in infer below.
	$(FLATPPL) lint --allow not-canonical --allow unresolved-name --deny-warnings $(IMPORT_MODELS)
	@set -e; scratch=$$(mktemp -d); trap 'rm -f "$$scratch/check.flatpir"; rmdir "$$scratch"' EXIT; \
	for model in $(MODELS); do $(FLATPPL) infer --no-header "$$model" "$$scratch/check.flatpir"; done

$(BUILD):
	mkdir -p $@

$(PDFS): $(BUILD)/%.pdf: %.typ $(COMMON) | $(BUILD)
	typst compile --root .. --ignore-system-fonts --font-path fonts $< $@

$(MODEL_SHEETS:%=$(BUILD)/%.pdf): $(BUILD)/%.pdf: examples/%.flatppl
$(FIGURE_SHEETS:%=$(BUILD)/%.pdf): $(BUILD)/%.pdf: figures/%.svg
$(BUILD)/neutrino-physics.pdf: examples/three-flavour.flatppl
$(BUILD)/cli.pdf: examples/score.flatppl examples/ws.json examples/hs.json examples/r.formula.json
$(BUILD)/python-sdk.pdf: examples/python_sdk.py
$(BUILD)/fitting-from-python.pdf: examples/fit.py
