#import "theme.typ": *

#let accent = rgb("365d70")
#let file = "examples/einstein-reductions.flatppl"
#let source = read(file)
#attach-example(file)

#let example(title, name, result, rhs: false) = {
  let statement = source.match(regex("(?m)^" + name + "(?:\\[| = ).*(?:\\n +[^\\n]+)*")).text
  let listing = if rhs { statement.split(" = ").at(1) } else { statement }
  (title, code(listing, size: 8.8pt), result)
}

#let heading(body) = text(size: 7.9pt, weight: "bold", fill: secondary, body)
#let panel(title, inputs, rows) = block(width: 100%, breakable: false)[
  #block(width: 100%, stroke: (bottom: 0.65pt + accent), inset: (bottom: 3pt))[
    #subhead(title, size: 13.3pt)
  ]
  #block(width: 100%, inset: (x: 4pt, y: 5pt), inputs)
  #table(
    columns: (86pt, 1fr, 86pt),
    inset: (x: 4pt, y: 3pt),
    align: (col, _) => (if col == 2 { center } else { left }) + horizon,
    stroke: none,
    table.header(heading[Operation], heading[FlatPPL], heading[Result]),
    table.hline(stroke: 0.6pt + rule),
    ..rows.enumerate().map(((index, row)) => (
      ..row,
      if index < rows.len() - 1 { table.hline(stroke: 0.35pt + rule) },
    )).flatten().filter(x => x != none),
  )
]

#let slices(first, second) = grid(columns: (1fr, 1fr), column-gutter: 3pt,
  align: center + horizon, first, second)

#let indexing = panel("Select, reorder and broadcast", [
  $A = mat(delim: "[", 1,2,0;3,1,4), quad D = mat(delim: "[", 2,5;7,3),
    quad u=[1,2], quad U=mat(delim: "[", 1;2)$
], (
  example([Square entries], "square", $mat(delim: "[", 1,4,0;9,1,16)$),
  example([Row sums], "rows", $[3,8]$),
  example([Column sums], "cols", $[4,3,4]$),
  example([Sum both axes], "total", $11$),
  example([Transpose], "swap", $mat(delim: "[", 1,3;2,1;0,4)$),
  example([Select column 2], "second", $[2,1]$),
  example([Keep the diagonal], "diag_cells", $[2,3]$),
  example([Sum the diagonal], "diag_total", $5$),
  example([Add by row], "add_col", $mat(delim: "[", 2,3,1;5,3,6)$),
  example([Scale by row], "scale_rows", $mat(delim: "[", 1,2,0;6,2,8)$),
))

#let contractions = panel("Multiply and contract", [
  $B = mat(delim: "[", 1,2;3,1), quad C = mat(delim: "[", 2,0;1,3),
    quad u=[1,2], quad v=[3,4], quad w=[2,1]$
], (
  example([Dot product], "dot_uv", $11$),
  example([Outer product], "outer_uv", $mat(delim: "[", 3,4;6,8)$),
  example([Matrix × vector], "mv", $[11,13]$),
  example([Matrix × matrix], "mm", $mat(delim: "[", 4,6;7,3)$),
  example([Entrywise product], "hadamard", $mat(delim: "[", 2,0;3,3)$),
  example([Row dot products], "row_dot", $[2,6]$),
  example([Frobenius product], "frobenius", $8$),
  example([Weight the sum], "mm_w", $mat(delim: "[", 6,6;13,3)$),
  example([Weighted squared differences], "loss", $mat(delim: "[", 3,3;2,22)$),
  example([Bilinear form], "bilinear", $37$),
))

#let trace = block(width: 100%, stroke: (top: 0.65pt + accent), inset: (x: 4pt, y: 5pt))[
  #subhead("Read one cell of the matrix product", size: 11.2pt)
  #v(4pt)
  #grid(columns: (auto, 1fr), column-gutter: 10pt, align: horizon,
    $underbrace(mat(delim: "[", 3,1), "row 2 of " B)
      dot underbrace(mat(delim: "[", 2;1), "column 1 of " C)
      = 3 dot 2 + 1 dot 1 = 7$,
    [Fix `.i` at 2 and `.k` at 1. Pair entries with the same `.j`, then sum over `.j`.])
  #v(5pt)
  Write the row sums explicitly as `aggregate(sum, [.i], A[.i, .j])`.
]

#let rank-three = panel("Index rank-three arrays", [
  $X_1 = mat(delim: "[", 1,2;3,4), quad X_2 = mat(delim: "[", 5,6;7,8),
    quad V = mat(delim: "[", 1,2;2,1), quad C = mat(delim: "[", 2,0;1,3)$
  #v(3pt)
  $H_1 = mat(delim: "[", 1,2,3), quad H_2 = mat(delim: "[", 4,5,6), quad q=[1,0,1]$.
  `X` has shape $2×2×2$ and `H` has shape $2×1×3$. Read two matrices side by side as consecutive slices along the first axis.
], (
  example([Take slice 1], "first_slice", $mat(delim: "[", 1,2;3,4)$),
  example([Sum each slice], "slice_sums", $[10,26]$),
  example([Sum middle axis], "middle", $mat(delim: "[", 4,6;12,14)$),
  example([Trace by slice], "traces", $[5,13]$),
  example([Move `.j` first], "rotate", slices($mat(delim: "[", 1,3;5,7)$,$mat(delim: "[", 2,4;6,8)$)),
  example([Vector per slice], "batch_mv", $mat(delim: "[", 5,11;16,22)$),
  example([Shared matrix], "batch_mm", slices($mat(delim: "[", 4,6;10,12)$,$mat(delim: "[", 16,18;22,24)$)),
  example([Sum all squares], "norm_sq", $204$),
  example([Drop middle axis], "rect_sum", $mat(delim: "[", 1,2,3;4,5,6)$),
  example([Contract length 3], "rect_mv", $mat(delim: "[",4;10)$),
))

#let reducers = panel("Choose the reduction", [
  $W = mat(delim: "[", 1,2,6;2,4,6), quad B = mat(delim: "[", 1,2;3,1), quad C = mat(delim: "[", 2,0;1,3)$
  #h(4pt)
  Sample `var` and `std` use $n-1$.
], (
  example([Sum], "r_sum", $[9,12]$, rhs: true),
  example([Product], "r_prod", $[12,48]$, rhs: true),
  example([Minimum], "r_min", $[1,2]$, rhs: true),
  example([Maximum], "r_max", $[6,6]$, rhs: true),
  example([Mean], "r_mean", $[3,4]$, rhs: true),
  example([Median], "r_median", $[2,4]$, rhs: true),
  example([Sample variance], "r_var", $[7,4]$, rhs: true),
  example([Sample std. dev.], "r_std", $[sqrt(7),2]$, rhs: true),
  example([Any by column], "r_any", text(font: mono, size: 7pt, "[false,true,true]"), rhs: true),
  example([All by column], "r_all", text(font: mono, size: 7pt, "[false,false,true]"), rhs: true),
  example([Maximum of all], "r_max_global", $6$, rhs: true),
  example([All below 6], "r_safe", `false`, rhs: true),
  example([Count matches], "hits", $[1,2]$),
  example([Product of pairwise sums], "pair_prod", $mat(delim: "[", 9,5;10,12)$),
))

#sheet-page("Einstein summation and reductions", "Indexed arrays", accent,
  ("Read the output indices", text(size: 9.8pt)[
    Keep the listed axes in order and reduce the others. `:=` uses `sum`. A repeated name pairs equal positions on axes of the same length. `!` selects a singleton axis.
  ]),
  grid(columns: (1fr,1fr), column-gutter: 13pt,
    stack(dir: ttb, spacing: 8pt, indexing, contractions, trace),
    stack(dir: ttb, spacing: 8pt, rank-three, reducers)),
)
