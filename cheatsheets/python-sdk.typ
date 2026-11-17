#import "theme.typ": *

#let py(source) = code(source, lang: "python")
#let install = "https://github.com/flatppl/flatppl-python/blob/b88d0f3d1eb613a5d1f0a230d437272c997611e5/docs/installation.md"
#let scores = table(
  columns: (0.7fr, 1.4fr, 1.2fr), align: right, stroke: none,
  inset: (x: 6pt, y: 4pt),
  table.hline(stroke: 0.6pt + rule),
  table.header([$x$], [Log density], [Slope in $x$]),
  table.hline(stroke: 0.4pt + rule),
  [$-1$], [−1.41894], [$+1$],
  [$0$], [−0.91894], [$0$],
  [$1$], [−1.41894], [$-1$],
  table.hline(stroke: 0.6pt + rule),
)

#sheet(
  name: "python-sdk", file: "examples/python_sdk.py", lang: "python",
  topic: "Python SDK", title: "FlatPPL for Python", accent: rgb("365d70"),
  formula: ("Scalar query", [$ell(x, mu) = -frac((x-mu)^2 + log(2 pi), 2)$]),
  example: "A FlatPPL query as a JAX function",
  reference-title: "Results and API calls",
  illustration: ("Check the values at μ = 0", scores, [
    The batched call returns the middle column. The derivative is $mu-x$, so opposite displacements have equal scores and opposite slopes.
  ]),
  notes: (
    ("Load and compile", 7, 9, [
      `load` reads the model beside the driver. `compile()` uses its `inputs` and `outputs` declarations to build a callable. Keep this function for subsequent calls.
    ]),
    ("Pass a point by name", 11, 12, [
      Keyword arguments use the FlatPPL input names. The equivalent positional call is `score(1.0, 0.0)`. The result is a scalar JAX array. `float` converts it for printing.
    ]),
    ("Differentiate one argument", 14, 16, [
      `argnums=0` selects the first positional input, `x`. The transformed call returns the log density and its derivative. At this point the derivative is −1.
    ]),
    ("Batch over the observations", 18, 20, [
      `in_axes=(0, None)` takes successive values of `x` from the first axis of `xs` and reuses one scalar mean. Three inputs give three log densities.
    ]),
  ),
  after-notes: (
    entry("Inspect a binding", [
      #py("names = tuple(model.parameters)\ndomain = model.bindings[\"x\"].domain")
      #v(3pt)
      Here `names` is `("x", "mu")`. The binding for `x` records its real domain. The model text is available as `model.source`.
    ]),
  ),
  variants: (
    entry("The companion file · score.flatppl", [
      #code(read("examples/score.flatppl").trim())
      #v(3pt)
      The tuple fixes the positional argument order. Each call supplies both values to the same compiled query.
    ]),
    entry("Work in a notebook", [
      #py("from flatppl import flatppl\ninline = flatppl(model.source)\nf = inline.compile()")
      #v(3pt)
      Pass a string of FlatPPL source to `flatppl`. Use `load` for files and portable model ZIPs.
    ]),
    entry("Run the driver", [
      #code("python examples/python_sdk.py", lang: "bash")
      #v(3pt)
      Run this command from the cheatsheets directory. The #link(install, underline[SDK installation guide]) lists the matching compiler, JAX, and Enzyme packages.
    ]),
  ),
  references: (
    entry("Query a new expression", [
      #py("q = model.query({\"hi\": \"mu + 2.0\"})\nhi = q.compile()({\"mu\": 1.0})[\"hi\"]")
      #v(3pt)
      The SDK builds a query over the parameters the expression uses. This one takes a record with one field and returns 3.
    ]),
    entry("Bind a data set", [
      #py("other = path.with_name(\n    \"fitting-from-python.flatppl\")\nm = load(other).set(observed=[0.5, 1.5] * 4)\ntarget = m.logdensity(\"L\", jacobian=False)")
      #v(3pt)
      The fitting sheet declares `observed` as an external vector of length eight. The bound module supplies a likelihood in free coordinates. `target.potential` gives its negative log likelihood for minimization.
    ]),
    entry("Pass a posterior to a sampler", [
      #py("rate = load(path.with_name(\n    \"zero-to-hero.flatppl\"))\npost = rate.logdensity(\"posterior\")")
      #v(3pt)
      Give the sampler `post` and its starting point `post.init`. The default includes the log-Jacobian. Apply `post.constrain` to recover rates from sampled free coordinates.
    ]),
    entry("Choose precision", [
      #py("with jax.enable_x64(True):\n    f64 = model.compile(dtype=\"float64\")\n    value64 = f64(1.0, 0.0)")
      #v(3pt)
      The default is float32. For array inputs, match the declared shape and the compiled dtype.
    ]),
  ),
)
