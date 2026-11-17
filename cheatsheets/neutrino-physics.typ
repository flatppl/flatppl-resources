#import "theme.typ": *

#sheet(
  topic: "Neutrino physics", title: "Neutrino oscillations", accent: rgb("46654f"),
  formula: ("Two-flavour vacuum appearance", [$P = sin^2(2 theta) sin^2 Phi$]),
  reference-title: "Propagation and response",
  file: "examples/neutrino-physics.flatppl", example: "Appearance in four energy bins",
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
      In increasing energy order, `pred` gives approximately `[0.06685, 0.08732, 0.06481, 0.04308]`. At zero baseline or zero mixing the appearance probabilities vanish.
    ]),
    entry("Fold in energy response", [
      #code("detected = response * true_expected")
      #v(3pt)
      Integrate flux, cross section, efficiency and probability together over each true-energy bin. Response rows label detected bins and columns label true bins.
    ]),
  ),
  references: (
    entry("Three-flavour transition matrix", [
      #code("p = nu.parameters(t12, t13, t23,\n    delta, dm21, dm31)\nP = nu.vacuum_probabilities(E, L, p, false)")
      #v(3pt)
      Load #module-link("flatppl-physics-neutrinos", "6c8aa0eaa169e5b2046b44e5941392e3816a3566")[`flatppl-physics-neutrinos`] as `nu`. Matrix rows label final flavour and columns initial flavour, in electron, muon, tau order. `P[1,2]` is muon-to-electron appearance.
    ]),
    entry("Propagate through matter", [
      #code("P = nu.matter_probabilities(\n    E, L, p, electron_density, false)")
      #v(3pt)
      Supply electron density in mol of electrons per cm³. Set the final argument to `true` for antineutrinos. For successive matter layers, compose their amplitudes before taking the absolute square.
    ]),
    entry("Set the mass ordering", [
      `dm21` is positive. Use `dm31 > dm21` for normal ordering or `dm31 < 0` for inverted ordering. The library expects both splittings in eV².
    ]),
    entry("Use expected event yields", [
      #code("expected = unoscillated_yield .* (\n    efficiency .* probability) .+ background\ny_flux ~ Poisson.(expected)")
      #v(3pt)
      Include incident flux, cross section and exposure in `unoscillated_yield`. Use this count model when the trial total is unknown.
    ]),
  ),
)
