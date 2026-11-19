#import "theme.typ": *

#let accent = rgb("365d70")
#let file = "examples/einstein-reductions.flatppl"
#let source = read(file)
#attach-example(file)

#let example(name, result, rhs: false) = {
  let statement = source.match(regex("(?m)^" + name + "(?:\\[| = ).*(?:\\n +[^\\n]+)*")).text
  let listing = if rhs { statement.split(" = ").at(1) } else { statement }
  block(width: 100%, breakable: false)[
    #block(width: 100%, inset: (x: 3.5pt, y: 2pt), fill: accent.lighten(95%),
      stroke: (left: 0.9pt + accent), code(listing, size: 8.2pt))
    #v(2.2pt)
    #grid(columns: (auto, 1fr), column-gutter: 3.5pt, align: horizon,
      text(fill: accent, size: 9pt)[→], text(size: 10pt, result))
  ]
}

#let figures(first, second) = grid(columns: (1fr, 1fr), column-gutter: 4pt,
  align: horizon, first, second)

#let sum-table = [
  #set text(size: 9.2pt)
  #set align(center)
  #table(columns: (auto, 1fr, 1fr, 1fr, 1fr), inset: (x: 2pt, y: 2pt),
    stroke: 0.4pt + rule,
    fill: (x, y) => if x == 4 or y == 3 { accent.lighten(85%) }
      else if x == 0 or y == 0 { accent.lighten(94%) },
    [*$A$*], [$j=1$], [$j=2$], [$j=3$], [*Sum*],
    [$i=1$], [1], [2], [0], [*3*],
    [$i=2$], [3], [1], [4], [*8*],
    [*Sum*], [*4*], [*3*], [*4*], [*11*])
]

#sheet-page("Einstein summation and reductions", "Indexed arrays", accent,
  ("Read the output indices", text(size: 9.8pt)[
    Keep the listed axes in order. Reduce the other named axes. `:=` uses `sum`.
  ]),
  grid(columns: (1fr, 1fr, 1fr, 1fr), column-gutter: 10pt,
    column("Select and reorder", (
      entry("Input and its sums", [
        #sum-table
        #v(3pt)
        Rows use `.i`. Columns use `.j`.
      ]),
      entry("Keep both axes", [
        #example("square", $mat(delim: "[", 1,4,0; 9,1,16)$)
      ]),
      entry("Keep one axis or none", [
        #example("rows", $[3, 8]$)
        #v(2pt)
        #example("cols", $[4, 3, 4]$)
        #v(2pt)
        #example("total", $11$)
      ]),
      entry("Swap axes", [
        #example("swap", $mat(delim: "[", 1,3; 2,1; 0,4)$)
      ]),
      entry("Fix the column index", [
        #example("second", $[2, 1]$)
      ]),
      entry("Pair the diagonal indices", [
        $D = mat(delim: "[", 2,5; 7,3)$
        #v(3pt)
        #example("diag_cells", $[2,3]$)
        #v(2pt)
        #example("diag_total", $5$)
      ]),
    ), accent, gap: 2.5pt),
    column("Multiply and contract", (
      entry("Inputs", [
        $u=[1,2], quad v=[3,4], quad w=[2,1]$
        #v(2pt)
        #figures($B=mat(delim: "[", 1,2;3,1)$, $C=mat(delim: "[", 2,0;1,3)$)
      ]),
      entry("Dot product", [
        #example("dot_uv", $1 times 3 + 2 times 4 = 11$)
      ]),
      entry("Outer product", [
        #example("outer_uv", $mat(delim: "[", 3,4;6,8)$)
      ]),
      entry("Matrix times vector", [
        #example("mv", $[11,13]$)
      ]),
      entry("Matrix times matrix", [
        #example("mm", $mat(delim: "[", 4,6;7,3)$)
      ]),
      entry("Dot product of matching rows", [
        #example("row_dot", $[2,6]$)
      ]),
      entry("Weight the summed axis", [
        #example("mm_w", $mat(delim: "[", 6,6;13,3)$)
      ]),
      entry("Sum over both independent axes", [
        #example("bilinear", $37$)
      ]),
    ), accent, gap: 2.5pt),
    column("Rank-three arrays", (
      entry("Input slices along the first axis", [
        #figures($X_1=mat(delim: "[", 1,2;3,4)$, $X_2=mat(delim: "[", 5,6;7,8)$)
        #v(3pt)
        The shape of `X` is $2 times 2 times 2$. The first index `.b` selects a slice.
      ]),
      entry("Take the first slice", [
        #example("first_slice", $mat(delim: "[", 1,2;3,4)$)
      ]),
      entry("Sum each slice", [
        #example("slice_sums", $[10,26]$)
      ]),
      entry("Sum over the middle axis", [
        #example("middle", $mat(delim: "[", 4,6;12,14)$)
      ]),
      entry("Trace each slice", [
        #example("traces", $[5,13]$)
      ]),
      entry("Move the last axis to the front", [
        #example("rotate", figures($j=1 quad mat(delim: "[", 1,3;5,7)$, $j=2 quad mat(delim: "[", 2,4;6,8)$))
      ]),
      entry("Multiply by a vector per slice", [
        $V = mat(delim: "[", 1,2;2,1)$
        #v(3pt)
        #example("batch_mv", $mat(delim: "[", 5,11;16,22)$)
      ]),
      entry("Multiply each slice by one matrix", [
        $C = mat(delim: "[", 2,0;1,3)$
        #v(3pt)
        #example("batch_mm", figures($b=1 quad mat(delim: "[", 4,6;10,12)$, $b=2 quad mat(delim: "[", 16,18;22,24)$))
      ]),
    ), accent, gap: 2.5pt),
    column("Choose the reduction", (
      entry("Input", [
        $W = mat(delim: "[", 1,2,6;2,4,6)$
        #v(3pt)
        The numeric reductions keep `.i` and return one result per row.
      ]),
      entry("Numeric reductions", [
        #for (name, result) in (
          ("r_sum", $[9,12]$),
          ("r_prod", $[12,48]$),
          ("r_min", $[1,2]$),
          ("r_max", $[6,6]$),
          ("r_mean", $[3,4]$),
          ("r_median", $[2,4]$),
          ("r_var", $[7,4]$),
          ("r_std", $[sqrt(7),2]$),
        ) {
          example(name, result, rhs: true)
          v(2pt)
        }
        Both `var` and `std` use the sample variance with denominator $n-1$.
      ]),
      entry("Boolean reductions", [
        Keep `.j` to test each column.
        #v(3pt)
        #example("r_any", `[false, true, true]`, rhs: true)
        #v(2pt)
        #example("r_all", `[false, false, true]`, rhs: true)
      ]),
      entry("Count matches by row", [
        #example("hits", $[1,2]$)
      ]),
      entry("Multiply sums over one axis", [
        #figures($B=mat(delim: "[", 1,2;3,1)$, $C=mat(delim: "[", 2,0;1,3)$)
        #v(2pt)
        #example("pair_prod", $mat(delim: "[", 9,5;10,12)$)
      ]),
    ), accent, gap: 2.5pt),
  ),
)
