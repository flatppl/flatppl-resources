#import "theme.typ": *

#sheet(
  topic: "Gamma-ray astronomy", title: "Forward-folding a photon spectrum", accent: rgb("315b70"),
  formula: ("Expected source counts", [$s_r = sum_j M_(r j) T A_j w_j phi_j$]),
  reference-title: "Response matrix and exposure",
  file: "examples/gamma-ray-response.flatppl", example: "Three true energies, two detector bins",
  illustration: ("Migration into reconstructed bins",
    "Stacked bars show the source counts contributed by each of three true energies to two detector bins and to the lost fraction.",
    [Colour identifies the true energy. The first two bars give expected source counts in the reconstructed bins. The third gives the expected loss from the corresponding column deficits.]),
  notes: (
    ("True and reconstructed bin indices", 11, 12, [
      Each column gives the outcome probabilities at one true energy. Each row gives contributions to one reconstructed bin. The column sums are 0.8, 0.8 and 0.7.
    ]),
    ("Fold a differential flux", 14, 16, [
      At each true energy, multiply the attenuated power-law flux by effective area, exposure and quadrature weight. Apply the migration matrix to the resulting vector of expected counts.
    ]),
    ("Add the observation law", 22, 23, [
      Add the fixed background in each bin to its reconstructed signal. The control exposure is four times the signal exposure. Conditional on the flux amplitude, the four counts are independent.
    ]),
    ("Score one flux amplitude", 25, 28, [
      The kernel returns a named count vector for each region. At the specified amplitude the expected source counts are 16.0075 and 13.1101. The joint log likelihood is −14.91365.
    ]),
  ),
  after-notes: (
    entry("Check the units", [
      Energy is in TeV, effective area in cm², and exposure in seconds. Differential flux times an energy weight, area, and time gives a dimensionless expected count.
    ]),
  ),
  variants: (
    entry("Expected counts before and after migration", [
      #code("kept = aggregate(sum, [.j], M[.r, .j])\nlost = 1 .- kept")
      #v(3pt)
      Before migration the three energies contribute 37.0253 expected counts. The two reconstructed bins retain 29.1175. The expected loss is 7.9078.
      #v(4pt)
      #lookup((1.65fr, 1fr, 1fr, 1fr), ([True energy (TeV)], [0.5], [1], [2]), numeric: true,
        [Retained fraction], [0.8], [0.8], [0.7],
        [Lost fraction], [0.2], [0.2], [0.3])
    ]),
    entry("Interpret the spectral scale", [
      `a` is the unattenuated differential flux at 1 TeV. `tau` gives optical depth. The factor `exp.(-0.8 .* tau)` attenuates each energy before migration.
    ]),
  ),
  references: (
    entry("Write the fold with named axes", [
      #code("truth = time .* area .* width .* (\n    amplitude .* unit_flux)\ns[.r] := M[.r, .j] * truth[.j]")
      #v(3pt)
      `truth` contains the three expected counts before migration. Sum over true energy `.j` and retain reconstructed bin `.r`. The #module-link("flatppl-astro-gamma", "4ef7f6a001d6bf2701741653fa34a6a56019fe18")[gamma-ray module] implements the fold as `fold_spectrum`.
    ]),
    entry("Check each detector bin", [
      Sum each row for the expected source count. Then add the background for that detector bin.
      #v(3pt)
      #lookup((1.2fr, 1fr, 1fr, 1fr), ([True energy], [0.5 TeV], [1 TeV], [2 TeV]), numeric: true,
        [Bin 1], [13.4511], [2.5564], [0],
        [Bin 2], [1.9216], [7.6693], [3.5192])
    ]),
    entry("Detection losses", [
      A column deficit is the probability of an event falling outside the selected bins. Renormalizing that column assigns the lost events to the measured bins.
    ]),
    entry("Scale the exposure", [
      At fixed spectrum, doubling the observing time doubles every expected source count. Changing the flux amplitude has the same linear effect on the signal.
    ]),
  ),
)
