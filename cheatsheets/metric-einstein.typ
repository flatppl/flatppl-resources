#import "theme.typ": *

// Align the component vectors with the two operands in the highlighted line.
#let components = context {
  let token(s) = text(font: mono, size: 9.4pt, s)
  block(inset: (left: 7pt), grid(
    columns: (measure(token("G: dist2[] := ")).width, measure(token("q[.i^] * ")).width, auto),
    align: left + horizon, column-gutter: 0pt,
    text(size: 8pt, fill: secondary, [Components]), token("[3, 1]"), token("[2, −1]"),
  ))
}

#sheet(
  topic: "Tensor coordinates", title: "Metric Einstein summation", accent: rgb("70516f"),
  formula: ("Squared Mahalanobis distance", [$d^2 = q^T G^(-1) q$]),
  reference-title: "Coordinate and likelihood checks",
  file: "examples/metric-einstein.flatppl", example: "One residual in two coordinate systems",
  illustration: ("One contour in two coordinate systems",
    "The circle through (2,1) becomes an ellipse through (3,1) after the shear. Both points have squared Mahalanobis distance 5.",
    [The same residual lies on the contour $d^2=5$ in both panels. The shear maps the circle to an ellipse. At fixed $q_1$, increasing $q_2$ increases $y$ and decreases $x$ by the same amount.]),
  notes: (
    ("Transform the covariance", 9, 10, [
      The original residual is `r = [2, 1]` with identity noise covariance. The instrument reports `q = [x + y, y]`. Its covariance is $G=J J^T$, with rows `[2, 1]` and `[1, 1]`.
    ]),
    ("Contract the two factors", 13, 13, [
      #components
      #v(2pt)
      #align(center, $3 times 2 + 1 times (-1) = 6 - 1 = 5$)
      #v(2pt)
      `.i^` reads the stored vector $q$. `.i_` reads $G^(-1)q$. The repeated index pairs the components. Their sum of products gives the original squared distance. Line 14 squares the stored entries and gives 10.
    ]),
    ("Check the lower components", 16, 17, [
      `linsolve` solves $2u_1+u_2=3$ and $u_1+u_2=1$. Subtract the equations to obtain $u_1=2$, then $u_2=-1$. Line 17 leaves `.i` free, so `parts` keeps both products `[6, -1]`.
    ]),
    ("Differentiate the squared distance", 19, 21, [
      In lower components the derivative is $2 G^(-1) q$, or `[4, −2]`. FlatPPL raises the lower output for storage as `[6, 2]`. Reading `grad[.i_]` recovers the derivative. A step along the second axis has slope −2.
    ]),
  ),
  after-notes: (
    entry("Finite displacement", [
      Hold the first reported component at 3. Increasing the second to $1+h$ yields the original residual $(2-h, 1+h)$. Its squared length is $5-2h+2h^2$, which verifies the derivative at $h=0$.
    ]),
  ),
  variants: (
    entry("The metric argument", [
      Pass the covariance `G` as the upper metric $g^(i j)$. Within a `G:` contraction, the marks on each index determine which components FlatPPL reads.
      #v(4pt)
      #lookup((auto, 1fr), ([Indexed expression], [Matrix rows]),
        [`G[.i^, .j^]`], [`[2, 1]`, `[1, 1]`],
        [`G[.i_, .j_]`], [`[1, -1]`, `[-1, 2]`],
        [`G[.i^, .j_]`], [`[1, 0]`, `[0, 1]`])
    ]),
    entry("The explicit contraction", [
      #code("d = metricsum(G, [], q[.i^] * q[.i_])")
      #v(3pt)
      Empty brackets request a scalar. Each repeated contracted index must occur once upper and once lower. A free index retains the variance declared on the left.
    ]),
  ),
  references: (
    entry("The Gaussian score", [
      The two-dimensional log density is $-frac(1,2)(d^2+log det G+2 log(2 pi))$. Here $det G=1$, so `log_L` is −4.33788. For a general change of scale the determinant also contributes.
    ]),
    entry("Change the units of both coordinates", [
      #code("q2 = 2 .* q\nG2 = 4 .* G\nG2: d2[] := q2[.i^] * q2[.i_]")
      #v(3pt)
      The squared distance stays 5. Doubling both coordinates multiplies area by four. The log density therefore falls by $log 4$.
    ]),
    entry("An index left free", [
      #code("G: T[.i^, .j^] := q[.i^] * q[.j^]\nG: w[.i^] := T[.i^, .j^] * q[.j_]")
      #v(3pt)
      `T` contains the outer product. Contracting its second slot gives $w^i = q^i d^2$. In reported coordinates the result is `[15, 5]`.
    ]),
    entry("Spacetime signature", [
      #code("eta = diagmat([1, -1, -1, -1])\np = [5, 3, 0, 0]\neta: m2[] := p[.a^] * p[.a_]")
      #v(3pt)
      A metric may be indefinite. With signature $(+, -, -, -)$ and $c=1$, this contraction gives the invariant mass squared $5^2-3^2=16$.
    ]),
  ),
)
