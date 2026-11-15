#import "theme.typ": *
#sheet(
  number: "07", title: "Neutrino oscillations", topic: "Physics",
  subtitle: "Two-flavour vacuum appearance with synthetic Binomial counts, followed by interfaces for three-flavour propagation.",
  accent: rgb("236d62"), file: "examples/neutrino-physics.flatppl",
  model_title: "Angle and mass-splitting inference",
  model_note: [A two-flavour vacuum reduction of the community neutrino example. It omits matter effects, other flavours, flux and detector response. The illustrative counts do not represent an experimental likelihood.],
  model_refs: (
    ref("Prediction at the stated point", [
      #code("pred = f_prob(theta=0.15, dm2=0.0025)")
      The four probabilities are approximately `[0.06685,0.08732,0.06481,0.04308]`. They come from the oscillation formula, independently of a sampling algorithm.
    ]),
  ),
  notes: (
    (1, "Units in a reusable function", 11, 13, [
      The probability is $sin(2 theta)^2 sin(1.266932679039099 Delta m^2 L/E)^2$. Energy uses GeV, baseline km, mass-squared splitting eV², and angle radians. The phase coefficient converts those units.
    ]),
    (2, "Broadcast over the energy bins", 15, 19, [
      The energy array varies by bin. The angle, splitting and baseline remain scalar. Broadcasting creates one probability per trial count. The Binomial model conditions on the trial totals.
    ]),
    (3, "A complete inference interface", 22, 25, [
      Both uncertain physical parameters enter the prior and kernel. The observation record contains only the appearance counts. Fixed energies, baseline and trial totals remain closed over in the kernel.
    ]),
    (4, "Separate model predictions from scores", 27, 30, [
      `f_prob` reifies the deterministic probability array. Its two inputs accept a matching record through auto-splatting. `log_L` scores the observed counts at the same physical parameter point.
    ]),
  ),
  notes_refs: (
    ref("Survival instead of appearance", color: graph-color, [
      #code("survival = 1 .- probability\nsurvived ~ Binomial.(trials, survival)")
      Choose appearance or survival counts from the same trials. Complementary counts are not independent data terms.
    ]),
  ),
  refs: (
    ref("Three-flavour library interface", [
      #code("p = nu.parameters(t12,t13,t23,\n    delta,dm21,dm31)\nP = nu.vacuum_probabilities(E,L,p,false)")
      Load the linked community library as `nu`. Probability rows are final flavour and columns are initial flavour. Flavour order is electron, muon, tau. `P[1,2]` means muon to electron.
    ]),
    ref("Matter and antineutrinos", [
      #code("P = nu.matter_probabilities(\n    E,L,p,electron_density,false)")
      Electron density uses mol of electrons per cm³, not bulk mass density. The final Boolean selects antineutrinos when true. The library keeps coherent amplitudes before taking their absolute square.
    ]),
    ref("Mass-ordering conventions", [
      `dm21` is positive. For normal ordering, require `dm31 > dm21`. For inverted ordering, `dm31 < 0`. Both splittings use eV². Angles and the CP phase use radians. These domains are caller preconditions.
    ]),
    ref("Counts from an incident flux", [
      #code("expected = unoscillated_yield .* (\n    efficiency .* probability) .+ background\ny_flux ~ Poisson.(expected)")
      The unoscillated yield includes flux, cross section and exposure. This replaces fixed-trial counts with expected event yields. Efficiency and background can carry nuisance parameters.
    ]),
    ref("Energy response and averaging", [
      #code("detected = response * true_expected")
      Rows denote detected bins and columns true bins. Integrate flux × cross section × efficiency × oscillation probability over each true-energy bin, then apply the response matrix.
    ]),
    ref("Physical limits and coherence", [
      Zero baseline or zero mixing gives zero appearance in the two-flavour model. Maximal mixing at phase $pi/2$ gives probability one. A full probability matrix has unit column sums. Compose layer amplitudes before squaring, not layer probabilities.
    ]),
  ),
  takeaway: [*Source:* `flatppl-physics-neutrinos/examples/playground`. Use the self-contained reduction for syntax, then replace its prediction function with a validated three-flavour and detector model.],
  sources: "Community: flatppl-physics-neutrinos · Reference: Units and conventions, Coherent propagation · Synthetic data",
)
