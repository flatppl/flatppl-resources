<img src="branding/logo-rounded.svg" alt="FlatPPL" width="72" align="right">

# FlatPPL resources

Cheatsheets and brand assets for FlatPPL.

## Cheatsheets

[Download the full set](cheatsheets/flatppl-cheatsheets.pdf), or choose a sheet:

- [Distributions](cheatsheets/distributions.pdf)
- [Language fundamentals](cheatsheets/beginner.pdf)
- [Functions and reification](cheatsheets/intermediate.pdf)
- [Measure algebra](cheatsheets/advanced.pdf)

Each A4 landscape sheet pairs a complete vertical example with numbered excerpts and side notes.
The sheets cover FlatPPL syntax and semantics, with syntax highlighting from the maintained FlatPPL grammar.
The [Typst sources and build instructions](cheatsheets/README.md) sit beside the PDFs.

## Branding

The [branding directory](branding/) contains copies of the FlatPPL logo, editable source art, wordmark, and favicon set.
The sheets use the [rounded squircle badge](branding/logo-rounded.svg).
Brand assets use [CC BY 4.0](branding/LICENSE.txt).

## Build

Install Typst 0.15.1 or later, then run:

```sh
make -C cheatsheets
```
