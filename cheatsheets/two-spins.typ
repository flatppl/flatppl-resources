#import "theme.typ": *

#sheet(
  topic: "Statistical mechanics", title: "Two spins and a partition function", accent: rgb("88533e"),
  formula: ("One bond at zero field", [$Z=e^K+e^(-K)+e^(-K)+e^K$]),
  reference-title: "State probabilities and degeneracy",
  file: "examples/two-spins.flatppl", example: "A finite Gibbs measure",
  illustration: ("Four states at two temperatures",
    "At K = 0 all four states have probability one quarter. At K = log(3)/2 the probabilities are three eighths, one eighth, one eighth and three eighths.",
    [The four pairs preserve the order of the spins. At the positive coupling in the listing, each aligned state is three times as likely as either opposed state.]),
  notes: (
    ("Bond energy and Boltzmann weight", 8, 9, [
      For one bond at zero field, write $K=beta J$ and $E=-J s_1 s_2$. The Boltzmann weights are $e^K$ for aligned spins and $e^(-K)$ for opposed spins.
    ]),
    ("Assemble the state space", 15, 19, [
      Place a unit `Dirac` mass at each ordered pair and multiply it by its Boltzmann weight with `weighted`. Add the four atoms with `superpose`. The pairs `[1, -1]` and `[-1, 1]` are distinct states.
    ]),
    ("Partition function and normalization", 21, 22, [
      Compute the partition function with `totalmass(M)`. `normalize(M)` divides each weight by this finite total. Both the weights and the normalizing constant depend on `K`.
    ]),
    ("Mass of an individual state", 24, 27, [
      On this discrete support, `densityof(P, pair)` gives the probability of one state. Sum the masses of the two aligned states for the probability of equal spins.
    ]),
  ),
  after-notes: (
    entry("Check the partition function", [
      Direct enumeration gives $Z=2 e^K+2 e^(-K)=4 cosh K$. At the stated coupling it equals $8/sqrt(3)$. The four probabilities sum to one.
    ]),
  ),
  variants: (
    entry("Spin correlation", [
      #code("closed_form = tanh(K)")
      #v(3pt)
      The product $s_1 s_2$ takes the value +1 for aligned spins and −1 for opposed spins. Its expectation, `correlation`, is $3/4-1/4=1/2$ at this coupling.
    ]),
    entry("Vary the temperature", [
      Set `ratio = 1` for $K=0$. All four atoms then have the same unit weight and probability $1/4$. For positive $J$, cooling increases $K$ and favours alignment.
    ]),
  ),
  references: (
    entry("Check symmetry", [
      Simultaneously reversing both spins preserves the energy. Hence `p_pp = p_mm` and `p_pm = p_mp`. Each individual spin still has equal probabilities of +1 and −1.
    ]),
    entry("Microstates per energy level", [
      Each energy level has two microstates. The probability of the aligned level is their combined mass. One aligned microstate has probability $3/8$.
    ]),
    entry("External magnetic field", [
      #code("weight(s, h) = exp(K * s[1] * s[2]\n    + h * sum(s))")
      #v(3pt)
      Include the dimensionless field `h` in each Boltzmann weight. Use the same four atoms and normalize the resulting measure.
    ]),
  ),
)
