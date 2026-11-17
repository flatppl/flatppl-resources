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
    ("Compile the model string", 11, 12, [
      `flatppl(source)` reads the five FlatPPL declarations in the Python string. `compile()` uses `inputs` and `outputs` to build the callable used below.
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
      Here `names` is `("x", "mu")`. The binding for `x` records its real domain. The model text is available as `model.source`.
    ]),
    entry("Differentiate each observation", [
      #py("dx = jax.grad(score, argnums=0)\nslopes = jax.vmap(dx, in_axes=(0, None))(\n    xs, 0.0)")
      #v(3pt)
      Differentiate the scalar query before batching it. At the three values in `xs` the slopes are $[1, 0, -1]$.
    ]),
  ),
  variants: (
    entry("The FlatPPL interface", [
      #code("inputs = (x, mu)\noutputs = logdensityof(Normal(mu, 1.0), x)")
      #v(3pt)
      The tuple fixes the positional argument order. Each call supplies both values to the same compiled query.
    ]),
    entry("Save and reload a model", [
      #py("from pathlib import Path\nfrom flatppl import load\npath = Path(\"normal.flatppl\")\npath.write_text(source, encoding=\"utf-8\")\nf = load(path).compile()")
      #v(3pt)
      `f` accepts the same arguments as `score`. `load` also reads portable model ZIPs.
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
      #py("extra = '''")
      #v(2pt)
      #code("datum = external(reals)\nK = functionof(Normal(mu, 1.0))\nL = likelihoodof(K, datum)\nprior = joint(mu = Normal(0.0, 1.0))\nposterior = bayesupdate(L, prior)")
      #v(2pt)
      #py("'''")
      #v(2pt)
      #py("m = flatppl(source + extra).set(datum=1.0)")
      #v(3pt)
      Append these declarations to the model string. `set` binds the observed reading to 1.
    ]),
    entry("Fit or sample the mean", [
      #py("target = m.logdensity(\"L\", jacobian=False)\npost = m.logdensity(\"posterior\")")
      #v(3pt)
      Minimize `target.potential` for a likelihood fit. A sampler takes `post` and `post.init`. Map draws to `mu` with `post.constrain`. Here the posterior mean is $1/2$ and its variance is $1/2$.
    ]),
    entry("Choose precision", [
      #py("with jax.enable_x64(True):\n    f64 = model.compile(dtype=\"float64\")\n    value64 = f64(1.0, 0.0)")
      #v(3pt)
      The default is float32. For array inputs, match the declared shape and the compiled dtype.
    ]),
  ),
)
