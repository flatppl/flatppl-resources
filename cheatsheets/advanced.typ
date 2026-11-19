#import "theme.typ": *

#let accent = rgb("70516f")
#let pair-table(title, values) = block(width: 100%)[
  #align(center, text(font: serif, size: 11pt, weight: "bold", title))
  #v(4pt)
  #set text(size: 9pt)
  #table(columns: (auto, 1fr, 1fr), align: center + horizon,
    stroke: none, inset: (x: 2.2pt, y: 4pt),
    fill: (x, y) => if x > 0 and y > 0 {
      let p = float(values.at((y - 1) * 2 + x - 1))
      if p > 0 { accent.lighten(100% - p * 68%) }
    },
    table.header([], [Normal], [Gamma]),
    table.hline(stroke: 0.5pt + rule),
    [Normal], values.at(0), values.at(1),
    [Gamma], values.at(2), values.at(3))
]

#let pairs = [
  Rows give the component of the first reading. Columns give the component of the second.
  #v(6pt)
  #grid(columns: (1fr, 1fr), column-gutter: 9pt,
    pair-table("Per reading", ("0.16", "0.24", "0.24", "0.36")),
    pair-table("Per batch", ("0.40", "0", "0", "0.60")))
]

#sheet(
  topic: "Advanced", title: "Measure composition", accent: accent,
  formula: ("Density of a single reading", [$m(y) = p f(y) + (1-p) g(y)$]),
  file: "examples/advanced.flatppl",
  example: "Two laws for five readings",
  reference-title: "Consequences of the component choice",
  illustration: ("Component pairs for two readings", pairs, [
    At $p = 0.4$, either reading has a 0.4 probability of a Normal origin before observation. With a fresh choice per reading, the components differ with probability $0.24 + 0.24 = 0.48$. A shared choice rules out both off-diagonal pairs.
  ]),
  notes: (
    ("Choose a component for each reading", 10, 14, [
      `mix` describes one observation. At fixed `p` and `mu`, `iid(mix, n)` repeats that law independently. Two readings in the same batch may come from different components.
    ]),
    ("Choose one component for the batch", 16, 17, [
      Each `iid` now describes five observations from a single component. `superpose` mixes the two five-dimensional laws. The readings share the component choice.
    ]),
    ("Bind the same five observations", 19, 23, [
      Both kernels take `p` and `mu` and return a law for the record field `y`. Binding the same `obs` to each kernel gives two likelihoods on the same parameter space.
    ]),
    ("Assign the common prior", 25, 27, [
      `joint` gives independent priors to `p` and `mu`. The field names match both likelihoods. Substitute `L_batch` for `L` to obtain the posterior under a shared component.
    ]),
  ),
  variants: (
    entry("Keep parameters and predicted readings", [
      #code("model = jointchain(prior, K)")
      #v(3pt)
      A draw contains `p`, `mu` and `y`. All five readings use that draw of the parameters. Under `K`, each reading still has its own component choice.
    ]),
    entry("Keep only the predicted readings", [
      #code("predictive = kchain(prior, K)")
      #v(3pt)
      A draw contains `y`. Its law integrates over `p` and `mu`. Use `K_batch` here to predict a batch with one shared component.
    ]),
    entry("Integrate out the mixing weight", [
      Under the Beta(2, 2) prior, both readings come from the Normal with probability $E[p^2]=3/10$ under `K` and $E[p]=1/2$ under `K_batch`. For either law, each marginal probability is $1/2$.
    ]),
  ),
  after-notes: (
    entry("Condition the joint model", [
      #code("given_y = restrict(model, obs)")
      #v(3pt)
      Fix the `y` field of `model` at the observed readings. This gives the same unnormalized measure on `p` and `mu` as `bayesupdate(L, prior)`.
    ]),
  ),
  references: (
    entry("The five-reading likelihoods", [
      Let $f_i$ and $g_i$ be the Normal and Gamma densities at reading $y_i$. In both models $p$ is the Normal weight.
      #v(4pt)
      $ L_"reading" &= product_i (p f_i + (1-p) g_i) \
        L_"batch" &= p product_i f_i + (1-p) product_i g_i $
    ]),
    entry("What one negative reading establishes", [
      The first reading is $-1.1$. Its Gamma density is zero, so this reading must come from the Normal. At fixed $p=0.4$, what is the probability that the next reading comes from the Gamma?
      #v(3pt)
      #lookup((1.4fr, 1fr), ([Choice], [Probability]), numeric: true,
        [Per reading], [$1-p=0.60$],
        [Per batch], [$0$])
    ]),
    entry("Score the two laws at the same point", [
      #lookup((1.4fr, 1fr), ([Component choice], [Log likelihood]), numeric: true,
        [Per reading], [$-8.93513$],
        [Per batch], [$-27.50312$])
      #v(3pt)
      These scores use `p = 0.4` and `mu = -1`. Set `y_data = [-1.1]` on line 5. With one reading, both log likelihoods become −1.48876.
    ]),
  ),
)
