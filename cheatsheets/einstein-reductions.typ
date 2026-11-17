#import "theme.typ": *

#sheet(
  topic: "Indexed arrays", title: "Einstein summation and reductions", accent: rgb("365d70"),
  formula: ("Two sensor calibrations", [$hat(y)_(t s) = sum_k X_(t k) B_(s k)$]),
  reference-title: "Residuals by run and sensor",
  file: "examples/einstein-reductions.flatppl", example: "Three runs, two sensors",
  illustration: ("Sums by run and by sensor",
    "Three rows of squared residuals have row sums 5, 4, and 2. The two column sums are 5 and 6. All six cells sum to 11.",
    [Each cell contains one squared residual. Sum across a row for the error in one run. Sum down a column for the error at one sensor. Both partitions give 11 in total.]),
  notes: (
    ("One prediction per run and sensor", 9, 10, [
      Write the output indices first. `.t` labels the run and `.s` the sensor. Both factors use `.k` to select the same coefficient. Run 3 at sensor 1 gives $1 times 1 + 2 times 2 = 5$.
    ]),
    ("One sum of squares per run", 12, 13, [
      `by_run` retains `.t`. FlatPPL sums over `.s` even though it occurs only once. The first residual is `[2, 1]`, so the first run contributes 5. Empty brackets sum all three contributions.
    ]),
    ("Means and logical reductions", 15, 17, [
      `mean` retains one result per sensor, $[5/3, 2]$. `lall` retains one result per run. Only run 3 has both readings within one unit of their predictions.
    ]),
    ("Pairs of sensor residuals", 19, 20, [
      Two free names, `.a` and `.b`, select sensors independently. The off-diagonal entry is $2 times 1 + 0 times 2 + 1 times (-1) = 1$. Reusing `.s` in the trace selects the diagonal entries 5 and 6.
    ]),
  ),
  after-notes: (
    entry("Gaussian likelihood", [
      Each reading has independent unit Normal error. The six readings give $log L = -3 log(2 pi) - 11/2 approx -11.01363$. The sum of squares in line 13 supplies the entire data-dependent term.
    ]),
  ),
  variants: (
    entry("Design and coefficient matrices", [
      A row of `X` is `[1, time]` at times 0, 1, and 2. A row of `B` is `[intercept, slope]` for one sensor. The two lines are $1+2t$ and $2-t$. The columns of `y` follow this sensor order.
    ]),
    entry("The explicit reduction", [
      #code("fitted = aggregate(sum, [.t, .s],\n    X[.t, .k] * B[.s, .k])")
      #v(3pt)
      `:=` abbreviates `aggregate(sum, …)`. Both forms produce three rows and two columns. Summing over the shared coefficient index implements $X B^T$.
    ]),
  ),
  references: (
    entry("Output order", [
      #code("T[.s, .t] := X[.t, .k] * B[.s, .k]")
      #v(3pt)
      Putting the sensor first gives a $2 times 3$ array. `T[1, 3]` and `pred[3, 1]` both contain the prediction 5.
    ]),
    entry("Paired and independent indices", [
      #code("diagonal[] := gram[.s, .s]\nall_cells[] := gram[.a, .b]")
      #v(3pt)
      `diagonal` sums two entries and gives 11. `all_cells` sums four entries and gives 13. A repeated name selects the same coordinate wherever it appears.
    ]),
    entry("Reduction operators", [
      Use `sum` or `prod` for totals and products, `minimum` or `maximum` for extrema, and `mean` or `median` for location. `var` and `std` use the sample denominator. `lany` and `lall` reduce Boolean values.
    ]),
    entry("Index lengths", [
      Every occurrence of a name spans the same number of entries. A numeric subscript fixes one position. For example, `r[1, .s]` selects both sensors in run 1.
    ]),
  ),
)
