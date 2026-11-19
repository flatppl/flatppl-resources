#import "theme.typ": *

#let paths = lookup((0.7fr, 1.35fr, 0.7fr, 1.35fr),
  ([Path], [Joint mass], [Path], [Joint mass]), numeric: true,
  [111], [0.012288], [211], [0.000768],
  [112], [0.012288], [212], [0.000768],
  [121], [0.004608], [221], [0.002688],
  [122], [0.043008], [222], [0.025088])

#sheet(
  topic: "Latent sequences", title: "Hidden Markov models", accent: rgb("365d70"),
  formula: ("Forward update", [$alpha_(t)(j) = e_(t)(j) sum_i alpha_(t-1)(i) T_(i j)$]),
  file: "examples/hidden-markov.flatppl",
  example: "Two states, three readings",
  reference-title: "Likelihood and state estimates",
  illustration: ("All eight paths", paths, [
    Each mass is joint with the observed sequence. For path 122, multiply
    $0.6 dot 0.8 dot 0.2 dot 0.8 dot 0.7 dot 0.8 = 0.043008$.
    The eight masses sum to 0.101504, so `ll` is −2.287657.
  ]),
  notes: (
    ("Combine transitions in log space", 9, 11, [
      State $j$ emits a 1 with probability $p_j$. The columns of `E` give the probabilities
      of readings 0 and 1. Select column `v + 1` for reading `v`. Each column of
      `H` gives the log transitions into one state. Combine the incoming scores with `logsumexp`.
    ]),
    ("Scan forward over the readings", 19, 21, [
      Seed the scan with $log alpha_(1)(j)=log(pi_(0)(j)e_(1)(j))$.
      `rest` holds readings 2 through `n`. Each scan step updates the state vector.
      The result excludes the seed, so prepend it with `cat`.
      The final vector gives `ll = logsumexp(A[n])`.
    ]),
    ("Scan backward over the readings", 23, 26, [
      Start with zero log future mass at the final time. Read `rest` in reverse.
      The callback applies the emission before the transition. Transpose `H` to sum
      over destinations. Restore time order in `B` and apply `softmax` to `A[t] .+ B[t]`.
    ]),
    ("Enumerate the eight paths", 34, 38, [
      The axes `.i`, `.j`, and `.k` select states at the first three times.
      Retain all three to get a $2×2×2$ array of joint path masses.
      Their sum matches `exp(ll)` for the three readings shown.
    ]),
  ),
  after-notes: (
    entry("What the scans carry", [
      The fourth argument passes the matrices as one record to each callback.
      With $K$ states and dense transitions, each update costs $O(K^2)$.
      The two scans give the full state history.
    ]),
  ),
  variants: (
    entry("Change the reading sequence", [
      Append readings to `y`. The scans use every reading. The path check uses the first three.
      With `p = [0.5, 0.5]`, any three readings have likelihood $1/8$.
    ]),
  ),
  references: (
    entry("Filter or smooth state 2", [
      Apply `softmax` to the forward log scores to use readings through $t$.
      Smoothing uses all three readings. The two estimates agree at $t=3$.
      #v(3pt)
      #lookup((0.65fr, 1fr, 1fr, 1fr), ([Time], [Reading], [Filtered], [Smoothed]), numeric: true,
        [1], [0], [0.142857], [0.288777],
        [2], [1], [0.598425], [0.742749],
        [3], [1], [0.799496], [0.799496])
    ]),
    entry("Forecast one step ahead", [
      Left-multiply the last filtered state vector by $T^top$ to get `pred`.
      Its second component is 0.599748. The next reading is a 1 with probability
      $sum_j p_j "pred"_j approx 0.559849$.
    ]),
    entry("Infer a path or an event", [
      The most probable path is 122. Its posterior mass is
      $0.043008 / 0.101504 approx 0.423707$.
      For a switch between readings 1 and 2, sum paths 121, 122, 211, and 212
      before dividing by 0.101504. The switch probability is 0.484237.
    ]),
    entry("Check one forward update", [
      `T[1, :]` predicts state 2 with probability 0.2 from state 1.
      `T[:, 2]` lists both ways to enter state 2.
      The incoming mass at time 2 is $0.48 dot 0.2 + 0.08 dot 0.7$.
      Multiply by the emission probability 0.8 to get $alpha_(2)(2)=0.1216$.
    ]),
    entry("Track the evidence after each reading", [
      Sum the two forward masses at each time. The ratios of consecutive sums
      give the probability of each new reading given the preceding ones.
      #v(3pt)
      #lookup((1.3fr, 1fr, 1fr, 1fr), ([Through time], [1], [2], [3]), numeric: true,
        [Joint probability], [0.56], [0.2032], [0.101504],
        [Conditional], [0.56], [0.362857], [0.499528])
    ]),
  ),
)
