#import "theme.typ": *
#let nu-path = "examples/three-flavour.flatppl"
#let nu-lines = read(nu-path).trim().split("\n")
#let nu-url = nu-lines.at(2).trim().trim("\"")

#sheet(
  topic: "Neutrino physics", title: "Neutrino oscillations", accent: rgb("46654f"),
  formula: ("Two-flavour vacuum appearance", [$P = sin^2(2 theta) sin^2 Phi$]),
  reference-title: "Propagation and response",
  file: "examples/neutrino-physics.flatppl", example: "Appearance in four energy bins",
  companions: (nu-path,),
  illustration: ("Appearance versus energy",
    "At 295 km the two-flavour probability peaks near 0.6 GeV. The four points are synthetic appearance counts divided by their trial totals.",
    [The curve uses $L=295$ km, $theta=0.15$ rad and $Delta m^2=0.0025$ eV². Each point is an observed fraction from 1000 synthetic trials.]),
  notes: (
    ("Units of the oscillation phase", 11, 13, [
      Supply energy `E` in GeV, splitting `d` in eV² and baseline `L` in km. The coefficient in `phase` converts these units. Supply the mixing angle in radians.
    ]),
    ("Appearance counts by energy", 15, 19, [
      Broadcast `appearance` over energy, holding the angle, splitting and baseline fixed. Each trial total has its own appearance probability. The product of Binomial laws conditions on the four totals.
    ]),
    ("Condition on appearance counts", 22, 25, [
      Declare `theta` and `dm2` as kernel inputs with the same names as their prior fields. The kernel retains the fixed energies, baseline and trial totals. Bind the measured counts to its output field `y`.
    ]),
    ("Appearance probabilities at a parameter point", 27, 30, [
      Pass `theta` and `dm2` by name in a record to obtain the probability vector from `f_prob`. Use `logdensityof(L, point)` for the log likelihood of the four counts at those values.
    ]),
  ),
  after-notes: (
    entry("Predict survival", [
      #code("survival = 1 .- probability\nsurvived ~ Binomial.(trials, survival)")
      #v(3pt)
      Subtract each appearance count from its trial total to obtain the survival count. Use one of the two complementary counts per bin.
    ]),
  ),
  variants: (
    entry("Values at the stated point", [
      #code("pred = f_prob(theta = 0.15, dm2 = 0.0025)")
      #v(3pt)
      At zero baseline or zero mixing, all four probabilities vanish.
      #v(4pt)
      #lookup((1.6fr, 1fr, 1fr, 1fr, 1fr), ([Energy (GeV)], [0.45], [0.6], [0.9], [1.2]), numeric: true,
        [Probability], [0.06685], [0.08732], [0.06481], [0.04308],
        [Observed fraction], [0.067], [0.087], [0.065], [0.043])
    ]),
    entry("Fold in energy response", [
      #code("true_mean = trials .* probability\nM = rowstack([[0.9, 0.8, 0.1, 0.0],\n              [0.1, 0.2, 0.9, 1.0]])\ndetected = M * true_mean")
      #v(3pt)
      Each column maps one true energy to two detector bins and sums to one. For broad bins, integrate the oscillated flux and cross section over energy.
    ]),
  ),
  references: (
    entry("Three-flavour transition matrix", [
      #code(nu-lines.slice(5, 10).join("\n"))
      #v(3pt)
      Bind `nu` with `load_module` using the #link(nu-url, underline[neutrino module URL]). The attached `three-flavour.flatppl` includes the import. Rows give final flavour and columns initial flavour in electron, muon, tau order. `P[1,2]` gives muon-to-electron appearance.
    ]),
    entry("Propagate through matter", [
      #code(nu-lines.slice(10, 12).join("\n"))
      #v(3pt)
      Electron density is 1.4 mol/cm³. Set the final argument to `true` for antineutrinos. For successive layers, compose amplitudes before taking the absolute square.
    ]),
    entry("Set the mass ordering", [
      The last two arguments of `nu.parameters` are `dm21` and `dm31` in eV². Use `dm21 > 0` and choose `dm31 > dm21` for normal ordering or `dm31 < 0` for inverted ordering.
    ]),
    entry("Use expected event yields", [
      #code("unosc = [800, 900, 1000, 750]\nexpected = 0.9 .* unosc .* probability .+ 2\ny_flux ~ Poisson.(expected)")
      #v(3pt)
      `unosc` includes flux, cross section and exposure. Each bin has 90% efficiency and two expected background events. Use Poisson counts when the trial total is unknown.
    ]),
  ),
)
