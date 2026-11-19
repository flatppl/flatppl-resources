#import "theme.typ": *

#let accent = rgb("365d70")
#let file = "examples/einstein-reductions.flatppl"
#let source = read(file)
#attach-example(file)

#let example(name, result, rhs: false) = {
  let statement = source.match(regex("(?m)^" + name + "(?:\\[| = ).*(?:\\n +[^\\n]+)*")).text
  let listing = if rhs { statement.split(" = ").at(1) } else { statement }
  (code(listing, size: 8.3pt), result)
}

#let small(body) = text(size: 8.7pt, body)
#let panel(title, inputs, rows) = block(width: 100%, breakable: false)[
  #block(width: 100%, stroke: (bottom: 0.6pt + accent), inset: (bottom: 2pt))[
    #subhead(title, size: 12pt)
  ]
  #block(width: 100%, inset: (x: 3pt, y: 3pt), small(inputs))
  #table(
    columns: (1fr, 54pt),
    inset: (x: 3pt, y: 1.5pt),
    align: (col, _) => (if col == 0 { left } else { center }) + horizon,
    stroke: none,
    ..rows.map(((listing, result)) => (
      table.hline(end: 1, stroke: 0.35pt + rule), listing,
      table.cell(inset: (x: 3pt, y: 2.25pt), {
        set math.mat(row-gap: 0.1em)
        small(result)
      }),
    )).flatten(),
  )
]

#let slices(first, second) = grid(columns: (1fr, 1fr), column-gutter: 2pt,
  align: center + horizon, first, second)

#let indexing = panel("Select, reorder and broadcast", [
  $A = mat(delim: "[", 1,2,0;3,1,4), quad D = mat(delim: "[", 2,5;7,3),
    quad u=[1,2], quad U=mat(delim: "[", 1;2)$
], (
  example("square", $mat(delim: "[", 1,4,0;9,1,16)$),
  example("rows", $[3,8]$),
  example("cols", $[4,3,4]$),
  example("total", $11$),
  example("swap", $mat(delim: "[", 1,3;2,1;0,4)$),
  example("second", $[2,1]$),
  example("diag_cells", $[2,3]$),
  example("diag_total", $5$),
  example("add_col", $mat(delim: "[", 2,3,1;5,3,6)$),
  example("scale_rows", $mat(delim: "[", 1,2,0;6,2,8)$),
))

#let contractions = panel("Multiply and contract", [
  $B = mat(delim: "[", 1,2;3,1), quad C = mat(delim: "[", 2,0;1,3), quad u=[1,2], quad v=[3,4], quad w=[2,1]$
], (
  example("dot_uv", $11$),
  example("outer_uv", $mat(delim: "[", 3,4;6,8)$),
  example("mv", $[11,13]$),
  example("mm", $mat(delim: "[", 4,6;7,3)$),
  example("hadamard", $mat(delim: "[", 2,0;3,3)$),
  example("row_dot", $[2,6]$),
  example("frobenius", $8$),
  example("mm_w", $mat(delim: "[", 6,6;13,3)$),
  example("loss", $mat(delim: "[", 3,3;2,22)$),
  example("bilinear", $37$),
))

#let anatomy = block(width: 100%, stroke: (top: 0.6pt + accent), inset: (top: 3pt))[
  #subhead("Read one cell of the matrix product", size: 11pt)
  #v(3pt)
  #align(center, $underbrace(mat(delim: "[", 3,1), "row 2 of " B)
      dot underbrace(mat(delim: "[", 2;1), "column 1 of " C)
      = 3 dot 2 + 1 dot 1 = 7$)
  #v(4pt)
  #small[Fix `.i` at 2 and `.k` at 1. Pair entries at the same `.j`, then sum over `.j`.]
  #v(7pt)
  #subhead("Check the output axes", size: 11pt)
  #v(3pt)
  #small[Each output name occurs in the expression and appears once on the left. With no omitted axes, `:=` returns one value per output position.]
  #v(4pt)
  #small[Here `A` is $2×3$. Keeping `.i` returns two row sums. Keeping `.j` returns three column sums. Keeping `.j, .i` returns a $3×2$ transpose.]
  #v(4pt)
  #code("rows = aggregate(sum, [.i], A[.i, .j])", size: 8.3pt)
]

#let rank-three = panel("Index rank-three arrays", [
  $X_1 = mat(delim: "[", 1,2;3,4), quad X_2 = mat(delim: "[", 5,6;7,8),
    quad V = mat(delim: "[", 1,2;2,1)$
  #linebreak()
  $H_1 = mat(delim: "[", 1,2,3), quad H_2 = mat(delim: "[", 4,5,6), quad q=[1,0,1]$. See $C$ at left.
  #linebreak()
  `X` is $2×2×2$. `H` is $2×1×3$. Paired matrices are successive slices along the first axis.
], (
  example("first_slice", $mat(delim: "[", 1,2;3,4)$),
  example("slice_sums", $[10,26]$),
  example("middle", $mat(delim: "[", 4,6;12,14)$),
  example("traces", $[5,13]$),
  example("rotate", slices($mat(delim: "[", 1,3;5,7)$,$mat(delim: "[", 2,4;6,8)$)),
  example("batch_mv", $mat(delim: "[", 5,11;16,22)$),
  example("batch_mm", slices($mat(delim: "[", 4,6;10,12)$,$mat(delim: "[", 16,18;22,24)$)),
  example("norm_sq", $204$),
  example("rect_sum", $mat(delim: "[", 1,2,3;4,5,6)$),
  example("rect_mv", $mat(delim: "[",4;10)$),
))

#let reducers = panel("Choose a reduction", [
  $W = mat(delim: "[", 1,2,6;2,4,6)$. Sample `var` uses $n-1$. `std` is its square root. $T$ and $F$ denote Boolean values.
  #v(3pt)
  Substitute each reducer name for `f` to reduce by row.
  #v(2pt)
  #code("aggregate(f, [.i], W[.i, .j])", size: 8.3pt)
  #v(2pt)
  #table(
    columns: (1fr, 1fr, 1fr, 1fr),
    align: (col, _) => (if calc.rem(col, 2) == 0 { left } else { center }) + horizon,
    inset: (x: 2pt, y: 2pt),
    stroke: none,
    table.vline(x: 2, stroke: 0.35pt + rule),
    table.hline(stroke: 0.35pt + rule),
    `sum`, $[9,12]$, `prod`, $[12,48]$,
    table.hline(stroke: 0.35pt + rule),
    `minimum`, $[1,2]$, `maximum`, $[6,6]$,
    table.hline(stroke: 0.35pt + rule),
    `mean`, $[3,4]$, `median`, $[2,4]$,
    table.hline(stroke: 0.35pt + rule),
    `var`, $[7,4]$, `std`, $[sqrt(7),2]$,
  )
], (
  example("r_any", $[F,T,T]$, rhs: true),
  example("r_all", $[F,F,T]$, rhs: true),
  example("r_max_global", $6$, rhs: true),
  example("r_safe", $F$, rhs: true),
  example("hits", $[1,2]$),
  example("pair_prod", $mat(delim: "[", 9,5;10,12)$),
))

#let gather = panel("Gather by position", [
  $p=[2,1,2]$, $c=[3,1]$. Repeated positions repeat entries. `:` selects a full axis. Positions start at 1.
], (
  example("pick", $[2,1,2]$),
  example("take", $mat(delim: "[", 0,1;4,3)$),
  example("along", $[0,4]$),
  example("subgrid", $mat(delim: "[", 4,3;0,1;4,3)$),
  example("by_get", $[1,2,0]$),
))

#let groups = panel("Reduce by group", [
  #grid(columns: (auto, 1fr), column-gutter: 8pt, align: horizon,
    $M=mat(delim: "[", 1,0;0,1;1,0;0,1)$,
    [$x=[3,2,5,4]$, $a=[1,1,2,1]$. Columns of $M$ mark membership. Use nonzero group counts and weight sums for the means.])
], (
  example("ng", $[2,2]$),
  example("totg", $[8,6]$),
  example("wg", $[3,2]$),
  example("atot", $[13,6]$),
  example("avg", $[4,3]$),
  example("wavg", $[13/3,3]$),
  example("topg", $[5,4]$),
))

#let stages = panel("Reduce in stages", [
  $R = mat(delim: "[", 1,6;3,2)$. Sample covariance here divides by $n-1=1$. Mark all tied column maxima in $W$.
], (
  example("mu", $[2,4]$),
  example("E", $mat(delim: "[", -1,2;1,-2)$),
  example("cov", $mat(delim: "[", 2,-4;-4,8)$),
  example("peak", $[2,4,6]$),
  example("ties", $mat(delim: "[", F,F,T;T,T,T)$),
))

#let algebra = panel("Change the pair rule or reduction", [
  $P=mat(delim: "[", 0,1;1,0), quad Q=mat(delim: "[", 1,0;1,1)$
  #h(3pt)
  `paths` tests for a two-step path through any `.j`.
], (
  example("minplus", $mat(delim: "[", 3,1;2,3)$),
  example("maxplus", $mat(delim: "[", 3,5;5,4)$),
  example("maxprod", $mat(delim: "[", 2,6;6,3)$),
  example("paths", $mat(delim: "[", T,T;T,F)$),
  example("triple", $mat(delim: "[", 22,14;16,17)$),
  example("loop3", $39$),
))

#let rank-four = panel("Retain four axes", [
  $K$ uses $B$ and $C$. The four $2×2$ blocks are indexed by `(.i, .j)`. Each block shows `(.k, .l)`.
], (
  example("K", block(inset: (y: 3pt), grid(
    columns: (1fr, 1fr), row-gutter: 10pt, column-gutter: 2pt, align: center,
    $mat(delim: "[", 2,0;1,3)$, $mat(delim: "[", 4,0;2,6)$,
    $mat(delim: "[", 6,0;3,9)$, $mat(delim: "[", 2,0;1,3)$))),
  example("kplane", $mat(delim: "[", 6,0;3,9)$),
  example("ksum", $mat(delim: "[", 6,12;18,6)$),
  example("ktrace", $10$),
))

#sheet-page("Einstein summation and reductions", "Indexed arrays", accent,
  ("Read the output indices", text(size: 9.3pt)[
    Retain the listed axes in order. Reduce the rest. `:=` uses `sum`. Repeated names pair equal positions on axes of equal length. `!` selects a singleton axis.
  ]),
  grid(columns: (1fr, 1fr, 1fr), column-gutter: 12pt,
    stack(dir: ttb, spacing: 7pt, indexing, contractions, anatomy),
    stack(dir: ttb, spacing: 5pt, rank-three, reducers, stages),
    stack(dir: ttb, spacing: 5pt, gather, groups, algebra, rank-four)),
)
