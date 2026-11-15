#import "theme.typ": *

#sheet(
  number: "02", title: "Language fundamentals", topic: "Beginner",
  subtitle: "Bindings, phases, collections, stochastic nodes, and likelihood construction.",
  accent: rgb("236d62"), file: "examples/beginner.flatppl",
  model_title: "Values, parameters, and variates",
  model_note: [A module is a flat graph of named expressions. Each name has one binding. Name references determine dependencies, independently of statement order.],
  notes: (
    (1, "Bindings and phases", 4, 7, [
      `sigma`, `y_data`, and `n` have fixed phase. `elementof(reals)` declares a parametric input without assigning a probability law.
    ]),
    (2, "Stochastic expressions", 10, 12, [
      `y ~ M` abbreviates `y = draw(M)`. The expression `y .- mu` uses the same variate `y`. The record groups values under named fields.
    ]),
    (3, "Kernels and observations", 15, 20, [
      `kernelof(y)` exposes the parametric leaf `mu` and closes over fixed ancestors. `likelihoodof` binds the observed array. Density evaluation takes a named parameter record.
    ]),
  ),
  refs: (
    ref("Binding syntax", [
      #code("a = 2 * b\nx ~ Normal(a, 1)")
      `=` binds an expression. `~` introduces a draw. Names may refer to bindings declared later in the file, provided the graph remains acyclic.
    ]),
    ref("Collections and indexing", [
      #code("v = [1.0, 2.0, 3.0]\nr = record(a = 1.0, b = 2.0)\nt = (1.0, 2.0)\nx = v[1]\nz = r.a")
      Arrays use 1-based indexing. Records have named fields. Tuples are ordered bundles and may contain different kinds of objects.
    ]),
    ref("Elementwise operations", [
      #code("b = a .+ v\nw = exp.(v)")
      Dotted operators and calls denote broadcasting. Undotted operators follow scalar and linear algebra rules. Canonical FlatPPL has no loop or conditional statements.
    ]),
    ref("Data and observations", [
      `_data` is a naming convention. It has no special syntax. A data binding becomes an observation when supplied to `likelihoodof` or `restrict`.
    ]),
    ref("Comments and documentation", [
      #code("# Plain comment.\n% Documentation attached to mu.\nmu = elementof(reals)")
      `#` comments are discarded by the parser. `%` documentation attaches to a binding. `%%%` delimits a block doc-comment.
    ]),
  ),
  takeaway: [*Phases:* fixed: no parameter or draw ancestors. Parametric: at least one `elementof` ancestor and no draw ancestor. Stochastic: at least one draw ancestor.],
  sources: "Specification: Objects, expressions, names and modules · Phases · Canonical syntax · Likelihood construction",
)
