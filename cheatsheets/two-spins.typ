#import "theme.typ": *

#sheet(
  topic: "Statistical mechanics", title: "Two spins and a partition function", accent: rgb("88533e"),
  formula: ("One bond at zero field", [$Z=e^K+e^(-K)+e^(-K)+e^K$]),
  reference-title: "Reading the Gibbs law",
  file: "examples/two-spins.flatppl", example: "A finite Gibbs measure",
  illustration: ("Four states at two temperatures",
    "At K = 0 all four states have probability one quarter. At K = log(3)/2 the probabilities are three eighths, one eighth, one eighth and three eighths.",
    [The four pairs preserve the order of the spins. At the positive coupling in the listing, each aligned state is three times as likely as either opposed state.]),
  notes: (
    ("Give each bond its energy", 8, 9, [
      Let $K=beta J$ and $E=-J s_1 s_2$. For aligned spins the Boltzmann weight is $e^K$. Opposed spins carry $e^(-K)$. The model has one bond and zero field.
    ]),
    ("Assemble the state space", 15, 19, [
      `Dirac` places unit mass at one ordered pair. `weighted` multiplies that mass. `superpose` adds all four atoms while keeping the arrangements `[1, -1]` and `[-1, 1]` distinct.
    ]),
    ("Turn weights into probabilities", 21, 22, [
      `totalmass(M)` gives the partition function. `normalize(M)` divides every state weight by that same finite total. Changing `K` changes both the weights and their normalizer.
    ]),
    ("Read an atom’s probability", 24, 27, [
      Here `densityof(P, pair)` gives the mass of that state on the discrete support. Add the two aligned states to find the chance that the spins agree.
    ]),
  ),
  after-notes: (
    entry("Check the partition function", [
      Direct enumeration gives $Z=2 e^K+2 e^(-K)=4 cosh K$. At the stated coupling it equals $8/sqrt(3)$. The four probabilities sum to one.
    ]),
  ),
  variants: (
    entry("A correlation from the same measure", [
      #code("closed_form = tanh(K)")
      #v(3pt)
      The product $s_1 s_2$ is +1 on aligned states and −1 on opposed states. Its expectation is `correlation`. At the stated coupling, $3/4-1/4=1/2$.
    ]),
    entry("Vary the temperature", [
      Set `ratio = 1` for $K=0$. All four atoms then have the same unit weight and probability $1/4$. For positive $J$, cooling increases $K$ and favours alignment.
    ]),
  ),
  references: (
    entry("Check symmetry", [
      Simultaneously reversing both spins preserves the energy. Hence `p_pp = p_mm` and `p_pm = p_mp`. Each individual spin still has equal probabilities of +1 and −1.
    ]),
    entry("Read the degeneracy", [
      There are two microstates at each energy. A probability for the aligned energy level therefore includes both aligned atoms. The probability of one particular aligned microstate is $3/8$.
    ]),
    entry("Change the physics locally", [
      #code("weight(s, h) = exp(K * s[1] * s[2]\n    + h * sum(s))")
      #v(3pt)
      Here `h` is the dimensionless field. Recompute each Boltzmann weight with this function. The four atoms and their normalization still apply.
    ]),
  ),
)
