#import "theme.typ": *

#sheet(
  topic: "Tensor language", title: "Metric Einstein summation", accent: rgb("70516f"),
  formula: ("A scalar contraction", [$u^i v_i = u^i g_(i j) v^j$]),
  reference-title: "Variance and storage",
  file: "examples/metric-einstein.flatppl", example: "Two vectors in an oblique basis",
  illustration: ("The angle in the physical plane",
    "The basis directions are (1,0) and (1,1). The physical vectors end at (3,1) and (1,2) and enclose 45 degrees.",
    [The basis vectors are $e_1=(1,0)$ and $e_2=(1,1)$. In Cartesian coordinates $u=(3,1)$ and $v=(1,2)$. Their angle is 45°.]),
  notes: (
    ("Supply the inverse Gram matrix", 6, 8, [
      FlatPPL stores upper components. Here `g` stores $g^(i j)$. Its inverse is the basis Gram matrix $g_(i j)$ with rows `[1, 1]` and `[1, 2]`.
    ]),
    ("Contract an upper and a lower index", 10, 12, [
      `.i^` reads stored components. `.i_` lowers them with `inv(g)`. Repeating the pair and leaving `[]` on the left gives a scalar. Here `uv = 5`, `uu = 10`, and `vv = 5`.
    ]),
    ("Inspect the lower components", 15, 16, [
      `v_down` gives `[1, 3]`. Its ordinary dot product with `u` is 5. Multiplying the two stored coordinate arrays directly gives `raw_dot = 0`.
    ]),
    ("Read a lower output back", 18, 19, [
      The right side computes twice the lower components, `[2, 6]`. FlatPPL raises the result for storage as `[-2, 4]`. The next contraction lowers `twice` on access and returns 10.
    ]),
  ),
  after-notes: (
    entry("Spell out the operator", [
      #code("uv_long = metricsum(g, [], u[.i^] * v[.i_])")
      #v(3pt)
      The metric prefix and `:=` in the listing express this call. Every tensor axis inside `metricsum` carries a variance mark.
    ]),
  ),
  variants: (
    entry("Start with covariant data", [
      #code("lower_values = [1.0, 3.0]\nv_upper = g * lower_values")
      #v(3pt)
      If a calculation gives lower components, convert them to the upper components FlatPPL stores. This recovers `[-1, 2]` in the example basis.
    ]),
    entry("Check the scalar independently", [
      In Cartesian coordinates $u dot v = 3 times 1 + 1 times 2 = 5$. Dividing by their lengths gives $cos theta = 5 / sqrt(50) = 1 / sqrt(2)$.
    ]),
    entry("Read a mixed metric index", [
      Within `metricsum`, `g[.i^, .j_]` represents the identity tensor. One multiplication by the inverse metric converts $g^(i k) g_(k j)$ into the Kronecker delta.
    ]),
  ),
  references: (
    entry("Check index pairs", [
      A repeated contracted name must occur exactly twice, once upper and once lower. A free name must match its output variance. A lone omitted index sums components and depends on the coordinates.
    ]),
    entry("Choose the metric", [
      Pass a symmetric, invertible square matrix of upper metric components. With `eye(n)`, lowering leaves components unchanged and the contraction agrees with ordinary sum aggregation.
    ]),
    entry("Form and contract a tensor", [
      #code("g: T[.i^, .j^] := u[.i^] * v[.j^]\ng: w[.i^] := T[.i^, .j^] * v[.j_]")
      #v(3pt)
      The outer product retains both indices. Contracting its second slot with `v` gives $u (v dot v)=5 u$. The stored result is `[10, 5]`.
    ]),
    entry("Use a spacetime metric", [
      #code("eta = diagmat([1, -1, -1, -1])\np = [5, 3, 0, 0]\neta: m2[] := p[.a^] * p[.a_]")
      #v(3pt)
      With $c=1$, this four-momentum has invariant mass squared $5^2-3^2=16$.
    ]),
  ),
)
