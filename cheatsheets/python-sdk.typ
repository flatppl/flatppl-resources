#import "theme.typ": *

#let py(source) = code(source, lang: "python")
#let install = "https://flatppl.org/flatppl-python/installation.html"
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
  name: "python-sdk", file: "examples/python_sdk.py", lang: "python", embedded: (6, 10),
  topic: "Python SDK", title: "FlatPPL for Python", accent: rgb("365d70"),
  formula: ("Scalar query", [$ell(x, mu) = -frac((x-mu)^2 + log(2 pi), 2)$]),
  example: "A FlatPPL query as a JAX function",
  reference-title: "Results and API calls",
  illustration: ("Check the values at μ = 0", scores, [
    The batched call returns the middle column. The derivative is $mu-x$, so opposite displacements have equal scores and opposite slopes.
  ]),
  notes: (
    ("Compile the declared query", 12, 12, [
      Pass a raw string to `flatppl`. Call `compile()` to get a function with the declared `inputs`. Each call evaluates the `outputs` expression.
    ]),
    ("Pass a point by name", 14, 15, [
      Keyword arguments use the FlatPPL input names. The equivalent positional call is `score(1.0, 0.0)`. The result is a scalar JAX array. `float` converts it for printing.
    ]),
    ("Differentiate one argument", 17, 19, [
      `argnums=0` selects the first positional input, `x`. The transformed call returns the log density and its derivative. At this point the derivative is −1.
    ]),
    ("Batch over the observations", 21, 23, [
      `in_axes=(0, None)` takes successive values of `x` from the first axis of `xs` and reuses one scalar mean. Three inputs give three log densities.
    ]),
  ),
  after-notes: (
    entry("Inspect a binding", [
      #py("names = tuple(model.parameters)\ndomain = model.bindings[\"x\"].domain")
      #v(3pt)
      Here `names` is `("x", "mu")`. The binding for `x` records its real domain. Read the FlatPPL text from `model.source`.
    ]),
    entry("Construct a regression from columns", [
      #py("from flatppl import from_formula\ndata = {\"x\": [0., 1., 2.], \"y\": [1., 2., 4.]}\nreg = from_formula(\"y ~ x\", data)")
      #v(3pt)
      The default family is Gaussian. The formula includes an intercept and one slope. Inspect the generated model in `reg.source`.
    ]),
  ),
  variants: (
    entry("The FlatPPL interface", [
      #code("inputs = (x, mu)\noutputs = logdensityof(Normal(mu, 1.0), x)")
      #v(3pt)
      The tuple fixes the positional argument order. Each call supplies both values to the same compiled query.
    ]),
    entry("Batch values and gradients together", [
      #py("both = jax.vmap(gradient, in_axes=(0, None))\nvalues, slopes = both(xs, 0.0)")
      #v(3pt)
      This returns two arrays of shape `(3,)`. Read the scores and slopes in the same order as `xs`.
    ]),
    entry("Save and reload a model", [
      #py("from flatppl import load\nmodel.save(\"normal.flatppl.zip\")\nf = load(\"normal.flatppl.zip\").compile()")
      #v(3pt)
      `save` writes a portable ZIP with the model and its dependencies. `load` opens a ZIP or a plain `.flatppl` file. The restored query accepts the same inputs.
    ]),
    entry("Run the driver", [
      #code("python python_sdk.py", lang: "bash")
      #v(3pt)
      Save the left listing as `python_sdk.py`, or run it in a notebook. The #link(install, underline[SDK installation guide]) lists the required packages.
    ]),
  ),
  references: (
    entry("Query a new expression", [
      #py("q = model.query({\"hi\": \"mu + 2.0\"})\nhi = q.compile()({\"mu\": 1.0})[\"hi\"]")
      #v(3pt)
      The SDK builds a query over the parameters the expression uses. This one takes a record with one field and returns 3.
    ]),
    entry("Bind an observed reading", [
      #py("m = flatppl(r\"\"\"")
      #v(2pt)
      #code("mu = elementof(reals)\ndatum = external(reals)\nK = functionof(Normal(mu, 1.0))\nL = likelihoodof(K, datum)\nprior = joint(mu = Normal(0.0, 1.0))\nposterior = bayesupdate(L, prior)")
      #v(2pt)
      #py("\"\"\").set(datum=1.0)")
      #v(3pt)
      `set` binds one observed value to the external `datum`. The mean remains free.
    ]),
    entry("Fit or sample the mean", [
      #py("target = m.logdensity(\"L\", jacobian=False)\npost = m.logdensity(\"posterior\")")
      #v(3pt)
      `logdensity` builds an inference target from a named law or likelihood. Minimize `target.potential` for the fit. Start a sampler at `post.init` and map draws with `post.constrain`. The posterior has mean and variance $1/2$.
    ]),
    entry("Choose precision", [
      #py("with jax.enable_x64(True):\n    f64 = model.compile(dtype=\"float64\")\n    value64 = f64(1.0, 0.0)")
      #v(3pt)
      The default is float32. For array inputs, match the declared shape and the compiled dtype.
    ]),
  ),
)
