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
    ("Make the units explicit", 11, 13, [
      The phase takes energy `E` in GeV, splitting `d` in eV² and baseline `L` in km. The factor in `phase` converts these units. The mixing angle goes into `sin` in radians.
    ]),
    ("Broadcast a physics function", 15, 19, [
      The dotted call to `appearance` applies the same angle, splitting and baseline at each energy. The result has one probability for each entry of `trials`. The Binomial product conditions on those four trial totals.
    ]),
    ("Condition on appearance counts", 22, 25, [
      `theta` and `dm2` appear in both the prior and the explicit kernel boundary. The kernel closes over the energies, baseline and trial totals. Supply the measured counts in its single output field `y`.
    ]),
    ("Evaluate a physical prediction", 27, 30, [
      `f_prob` returns the probability array at the two inputs. Its record argument supplies both fields by name. `logdensityof(L, point)` scores the four counts at the same parameter values.
    ]),
  ),
  after-notes: (
    entry("Predict survival", [
      #code("survival = 1 .- probability\nsurvived ~ Binomial.(trials, survival)")
      #v(3pt)
      For the same trials, each survival count is the trial total minus the appearance count. Use one of these complementary observations per bin.
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
    entry("Call the three-flavour library", [
      #code("p = nu.parameters(t12, t13, t23,\n    delta, dm21, dm31)\nP = nu.vacuum_probabilities(E, L, p, false)")
      #v(3pt)
      Load `flatppl-physics-neutrinos` as `nu`. Matrix rows label final flavour and columns initial flavour, in electron, muon, tau order. `P[1,2]` is muon-to-electron appearance.
    ]),
    entry("Propagate through matter", [
      #code("P = nu.matter_probabilities(\n    E, L, p, electron_density, false)")
      #v(3pt)
      Electron density is in mol of electrons per cm³. Set the final argument to `true` for antineutrinos. Compose amplitudes through successive layers before taking their absolute square.
    ]),
    entry("Set the mass ordering", [
      `dm21` is positive. Use `dm31 > dm21` for normal ordering or `dm31 < 0` for inverted ordering. The library expects both splittings in eV².
    ]),
    entry("Use expected event yields", [
      #code("expected = unoscillated_yield .* (\n    efficiency .* probability) .+ background\ny_flux ~ Poisson.(expected)")
      #v(3pt)
      `unoscillated_yield` includes incident flux, cross section and exposure. This formulation describes event yields when the trial total is unknown.
    ]),
  ),
)
