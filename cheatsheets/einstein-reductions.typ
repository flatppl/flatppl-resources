#import "theme.typ": *

#sheet(
  topic: "Array language", title: "Einstein summation and reductions", accent: rgb("365d70"),
  formula: ("A contraction", [$C_(i k) = sum_j A_(i j) B_(j k)$]),
  reference-title: "Reading an indexed expression",
  file: "examples/einstein-reductions.flatppl", example: "One product, two free axes",
  illustration: ("One cell of a matrix product",
    "A shaded row of A and column of B yield the three products 1, 0 and 5. Their sum is the first entry of C.",
    [For `C[1, 1]`, the first row of `A` meets the first column of `B`. The three values of `.j` contribute $1+0+5=6$.]),
  notes: (
    ("Name the free axes", 8, 8, [
      The left side fixes the output order. `.i` runs over two rows and `.k` over two columns. The right side also uses `.j`. Its three values are summed.
    ]),
    ("Expand the shorthand", 10, 11, [
      `:=` selects `sum`. In the long form, the first argument selects the reduction and the second lists the retained axes. Both expressions produce the same matrix.
    ]),
    ("Choose the reduction", 13, 14, [
      `col_var` keeps columns and reduces the two rows using sample variance. `row_max` keeps rows and finds each row’s largest entry. A reduced axis can appear just once.
    ]),
    ("Tie two axes to a diagonal", 16, 17, [
      In `C[.i, .i]` the same index selects the row and column together. Two independent names in `C[.i, .k]` visit all four cells. Both empty output lists return a scalar.
    ]),
  ),
  after-notes: (
    entry("Check the shapes", [
      #code("first[] := A[1, .j] * B[.j, 1]")
      #v(3pt)
      `A` is $2 times 3$, `B` is $3 times 2$, and `C` is $2 times 2$. The two dimensions named `.j` must have the same length.
    ]),
  ),
  variants: (
    entry("Compare rows with columns", [
      #code("w = [1, 2, 1]\nD[.i, .k] := w[.j] * (\n    A[.i, .j] - B[.j, .k])^2")
      #v(3pt)
      The output has the same two free axes as the product. Changing the body gives weighted squared distances. The first entry is 34.
    ]),
    entry("Permute the output", [
      The product is `[[6, 8], [10, 6]]`. Listing `[.k, .i]` stores `[[6, 10], [8, 6]]`. The factors and the contraction stay the same.
    ]),
    entry("Check three reductions", [
      `col_var` gives `[32, 2, 8]`. For column one, the two deviations from 5 are −4 and 4. `diagonal_sum` gives 12 and `total` gives 30.
    ]),
  ),
  references: (
    entry("Choose an operator", [
      `sum`, `prod`, `mean`, `median`, `minimum`, and `maximum` reduce numeric entries. `var` and `std` use the sample denominator. `lany` and `lall` reduce Boolean entries.
    ]),
    entry("Keep a batch axis", [
      #code("S = aggregate(sum, [.b, .i],\n    X[.b, .i, .j] * w[.j])")
      #v(3pt)
      Each batch and row has its own weighted sum. The same vector of weights serves every batch.
    ]),
    entry("Read the brackets", [
      Write every retained name once in the output list and use it in the body. A numeric subscript fixes one coordinate. Axis names are local to their enclosing expression.
    ]),
    entry("Reduce a logical condition", [
      #code("ok = aggregate(lall, [.i], A[.i, .j] > 0)")
      #v(3pt)
      This gives one Boolean per row. Both rows in the example satisfy the condition in every column.
    ]),
  ),
)
