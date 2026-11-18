#import "theme.typ": *

#let accent = rgb("386775")
#let term(title, equation, formula, options: "", note: none) = (
  title: title, equation: equation, formula: formula, options: options, note: note,
)

#let groups = (
  (title: "Population terms", intro: [
    $eta_i$ is the linear predictor for row $i$. Here $alpha$ is the intercept on the original covariate scale.
  ], terms: (
    term("Intercept alone", $eta_i = alpha$, "y ~ 1"),
    term("A line with an intercept", $eta_i = alpha + beta x_i$, "y ~ x"),
    term("A line through the origin", $eta_i = beta x_i$, "y ~ 0 + x"),
    term("The product alone", $eta_i = alpha + delta x_i z_i$, "y ~ x:z"),
    term("Both slopes and their interaction",
      $eta_i = alpha + beta_x x_i + beta_z z_i + delta x_i z_i$, "y ~ x * z"),
    term("A quadratic in one variable",
      $eta_i = alpha + beta_1 x_i + beta_2 x_i^2$, "y ~ x + I(x^2)",
      note: [`I(...)` evaluates the arithmetic inside the parentheses.]),
    term("All two-way interactions",
      $eta_i = alpha + sum_j beta_j u_j + sum_(j<k) gamma_(j k) u_j u_k$,
      "y ~ (x + z + w)^2", note: [At row $i$, $u = (x_i, z_i, w_i)$.]),
    term("A factor with a reference level",
      $eta_A = alpha, quad eta_B = alpha + delta$, "y ~ f",
      note: [The unordered factor `f` has levels A, B, in that order.]),
    term("One coefficient per level",
      $eta_A = beta_A, quad eta_B = beta_B$, "y ~ 0 + f"),
  )),
  (title: "Group effects and curves", intro: [
    Write $j = g_i$ for the group of row $i$. Conditional on their scales and correlations, the group effects are zero-mean Gaussian.
  ], terms: (
    term("Varying intercept", $eta_i = alpha + u_j + beta x_i$, "y ~ x + (1 | g)"),
    term("Varying intercept and slope",
      $eta_i = alpha + u_j + (beta + v_j) x_i$, "y ~ x + (1 + x | g)",
      note: [The group covariance includes a correlation parameter $rho$.]),
    term("Independent intercept and slope",
      $eta_i = alpha + u_j + (beta + v_j) x_i, quad rho = 0$,
      "y ~ x + (1 + x || g)"),
    term("Crossed group intercepts",
      $eta_i = alpha + u_(g_i) + r_(h_i)$, "y ~ (1 | g) + (1 | h)",
      note: [Each row belongs to one level of each grouping factor.]),
    term("Monotonic dose effect",
      $eta_i = alpha + b D sum_(k=1)^(d_i) zeta_k$, "y ~ mo(d)",
      note: [Integer doses run from 0 to $D$. The nonnegative steps $zeta_k$ sum to one, so $b$ is the mean change per step.]),
    term("A smooth curve", $eta_i = alpha + f(x_i)$, "y ~ s(x, k=6)",
      note: [`k=6` sets the thin-plate basis dimension. The fitted curve shares one smoothing scale.]),
    term("An exponential curve with two parameters",
      $eta_i = a exp(b x_i), quad a, b limits(tilde.op)^"iid" cal(N)(0,1)$,
      "y ~ a * exp(b * x)",
      options: "nlpars={\"a\": \"a ~ 1\", \"b\": \"b ~ 1\"},\npriors=[{\"class\": \"b\", \"nlpar\": p,\n         \"prior\": \"normal(0,1)\"}\n        for p in (\"a\", \"b\")]",
      note: [With `nlpars`, `*` multiplies in the response expression. Each named parameter requires a coefficient prior.]),
  )),
  (title: "Response laws and observation terms", intro: [
    In this column $eta_i = alpha + beta x_i$. The default family is Gaussian. Indented keywords are Python call arguments.
  ], terms: (
    term("Successes in a known number of trials",
      $Y_i tilde.op "Binomial"(n_i, p_i), quad "logit"(p_i) = eta_i$,
      "hits | trials(n) ~ x", options: "family=\"binomial\""),
    term("Counts per unit exposure",
      $Y_i tilde.op "Poisson"(t_i exp(eta_i))$, "count ~ x + offset(log(t))",
      options: "family=\"poisson\"", note: [The coefficient of $log t_i$ is fixed at one.]),
    term("A Poisson count with extra zeros",
      $Pr(Y_i = 0) = pi + (1-pi) e^(-lambda_i), quad lambda_i = e^(eta_i)$,
      "count ~ x", options: "family=\"zero_inflated_poisson\"",
      note: [`zi` is the extra-zero probability $pi$.]),
    term("Known error and residual variance",
      $Y_i tilde.op cal(N)(eta_i, s_i^2 + sigma^2)$, "y | se(s, sigma=TRUE) ~ x"),
    term("A predictor for the residual scale",
      $Y_i tilde.op cal(N)(eta_i, sigma_i^2), quad log sigma_i = gamma_0 + gamma_1 z_i$,
      "y ~ x", options: "dpars={\"sigma\": {\"formula\": \"sigma ~ z\"}}"),
    term("An interval-censored reading",
      $Pr(y_i < Y_i <= u_i) = F_(i)(u_i) - F_(i)(y_i)$, "y | cens(status, upper) ~ x",
      note: [For `status=2`, `y` and `upper` bound the interval. $F_i$ is the Gaussian CDF.]),
    term("A response restricted to a range",
      $p(y_i ∣ 0 < Y_i < 3) = frac(f_(i)(y_i), F_(i)(3) - F_(i)(0))$,
      "y | trunc(lb=0, ub=3) ~ x", note: [This density applies inside the range and is zero outside it.]),
    term("Weighted observations",
      $p(theta ∣ y) ∝ p(theta) product_i p(y_i ∣ theta)^(w_i)$,
      "y | weights(w) ~ x", note: [Nonnegative weights multiply the row log likelihoods in the posterior.]),
  )),
)

#let printed(t) = block(width: 100%, breakable: false)[
  #hairline
  #v(3.1pt)
  #subhead(t.title, size: 11.7pt)
  #v(2.6pt)
  #text(size: 11.2pt, t.equation)
  #v(3pt)
  #block(width: 100%, fill: accent.lighten(95%), stroke: (left: 1.1pt + accent),
    inset: (x: 5pt, y: 2.5pt))[
    #code(t.formula, lang: "r", size: 9.35pt)
    #if t.options != "" {
      v(1.4pt)
      pad(left: 6pt, code(t.options, lang: "python", size: 8.7pt))
    }
  ]
  #if t.note != none { v(2.8pt); text(size: 9.1pt, fill: secondary, t.note) }
]

// The attachment runs the same formulas and keyword arguments that appear in print.
#let start = ```python
from flatppl import from_formula

data = {
    "x": [-2., -1., 0., 1., 2., 3., 4., 5.],
    "z": [0., 1., 1., -1., 2., -1., 0., 1.],
    "w": [0.5, 1., 2., 1., 1., 0.5, 2., 1.5],
    "f": ["A", "B", "B", "A", "A", "B", "A", "B"],
    "g": ["I", "I", "II", "II", "III", "III", "I", "II"],
    "h": ["L", "R", "R", "L", "L", "R", "R", "L"],
    "d": [0, 1, 2, 3, 0, 1, 2, 3],
    "y": [0.3, 1.1, 0.8, 1.5, 2.1, 1.4, 2.3, 1.9],
    "hits": [0, 1, 0, 2, 3, 2, 0, 1],
    "n": [3, 4, 1, 5, 6, 3, 2, 3],
    "count": [0, 1, 0, 2, 4, 2, 0, 1],
    "t": [1., 1.5, 2., 0.5, 1., 2., 3., 1.],
    "s": [0.2, 0.3, 0.2, 0.4, 0.2, 0.3, 0.4, 0.2],
    "status": [0, 2, 0, 0, 2, 0, 0, 2],
    "upper": [3.] * 8,
}
```
#let calls = groups.map(group => group.terms.map(t => {
  let args = repr(t.formula) + ", data"
  let call = if t.options == "" { "from_formula(" + args + ")" } else {
    "from_formula(\n    " + args + ",\n    " + t.options.replace("\n", "\n    ") + ",\n)"
  }
  repr(t.title) + ": " + call + ","
}).join("\n")).join("\n")
#let report = ```python
if __name__ == "__main__":
    for title, model in examples.items():
        info = model.formula.info
        print(f"{title} ({info['family']})  {info['formula']}")
```
#let script = start.text + "\n\nexamples = {\n    " + calls.replace("\n", "\n    ") + "\n}\n\n" + report.text + "\n"
#pdf.attach("/formula_api.py", bytes(script),
  mime-type: "text/plain", relationship: "supplement",
  description: "Independent formula calls with example data")

#sheet-page("The formula API", "Regression formulas", accent,
  ("Python entry point", [
    #link("https://flatppl.org/flatppl-python/formula.html",
      code("from flatppl import from_formula\nfrom_formula(\"y ~ x\", data)", lang: "python", size: 9.4pt))
  ]),
  grid(columns: (1fr, 1fr, 1fr), column-gutter: 12pt,
    ..groups.map(group => column(group.title, (
      text(size: 9.45pt, fill: secondary, group.intro), ..group.terms.map(printed),
    ), accent, gap: 2.5pt))),
)
