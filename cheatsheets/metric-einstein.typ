#import "theme.typ": *

#sheet(
  topic: "Tensor coordinates", title: "Metric Einstein summation", accent: rgb("70516f"),
  formula: ("Squared Mahalanobis distance", [$d^2 = q^T G^(-1) q$]),
  reference-title: "Coordinate and likelihood checks",
  file: "examples/metric-einstein.flatppl", example: "One residual in two coordinate systems",
  illustration: ("One contour in two coordinate systems",
    "The circle through (2,1) becomes an ellipse through (3,1) after the shear. Both points have squared Mahalanobis distance 5.",
    [The same residual lies on the contour $d^2=5$ in both panels. The shear maps the circle to an ellipse. At fixed $q_1$, increasing $q_2$ increases $y$ and decreases $x$ by the same amount.]),
  notes: (
    ("Transform the covariance with the data", 9, 10, [
      The first run on the preceding sheet gives `r = [2, 1]` with identity noise covariance. The instrument now reports `q = [x + y, y]`. Its covariance is $G=J J^T$, with rows `[2, 1]` and `[1, 1]`.
    ]),
    ("Contract one upper and one lower index", 12, 14, [
      `.i^` reads the stored vector. `.i_` applies the inverse of the supplied metric. The metric contraction gives 5 in both systems. Summing the squares of the reported components gives $3^2+1^2=10$.
    ]),
    ("Recover the component products", 16, 17, [
      The precision matrix has rows `[1, −1]` and `[−1, 2]`. Multiplying it by `q` gives the lower components `[2, −1]`. The two products are 6 and −1. Their sum is 5.
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
      #lookup((auto, 1fr), ([Indexed expression], [Components here]),
        [`q[.i^]`], [Stored residual $(3, 1)$],
        [`q[.i_]`], [Lowered residual $(2, -1)$],
        [`G[.i^, .j^]`], [Covariance $G$],
        [`G[.i_, .j_]`], [Precision $G^(-1)$],
        [`G[.i^, .j_]`], [Identity $I_2$])
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
