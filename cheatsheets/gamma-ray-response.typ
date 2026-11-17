#import "theme.typ": *

#sheet(
  topic: "Gamma-ray astronomy", title: "Forward-folding a photon spectrum", accent: rgb("315b70"),
  formula: ("Expected source counts", [$s_r = sum_j M_(r j) T A_j w_j phi_j$]),
  reference-title: "Reading the detector response",
  file: "examples/gamma-ray-response.flatppl", example: "Three true energies, two detector bins",
  illustration: ("Where the expected photons go",
    "Stacked bars show the source counts contributed by each of three true energies to two detector bins and to the lost fraction.",
    [Each color labels a true energy. The first two bars give expected source counts in detector bins. The third collects the fraction missing from the migration columns.]),
  notes: (
    ("Orient the migration matrix", 11, 12, [
      A column gives the probabilities for one true energy. A row collects arrivals in one reconstructed bin. The column sums are 0.8, 0.8 and 0.7.
    ]),
    ("Fold a differential flux", 14, 16, [
      Multiply flux by effective area, exposure, and quadrature weight at each true energy. The matrix then redistributes expected counts. Here the flux is a power law times attenuation.
    ]),
    ("Add the observation law", 22, 23, [
      The signal-region mean adds the two fixed backgrounds to the reconstructed signal. The control exposure is four times as large. The four counts are conditionally independent.
    ]),
    ("Score one flux amplitude", 25, 28, [
      The kernel returns named arrays for both regions. At the stated amplitude, the detector receives 16.0075 and 13.1101 expected source counts. The joint log likelihood is −14.91365.
    ]),
  ),
  after-notes: (
    entry("Check the units", [
      Energy is in TeV, effective area in cm², and exposure in seconds. Differential flux times an energy weight, area, and time gives a dimensionless expected count.
    ]),
  ),
  variants: (
    entry("Recover the count balance", [
      #code("kept = aggregate(sum, [.j], M[.r, .j])\nlost = 1 .- kept")
      #v(3pt)
      The three true-energy contributions total 37.0253 expected counts before migration. The two reconstructed bins retain 29.1175. The remaining 7.9078 follow the lost fractions.
    ]),
    entry("Interpret the spectral scale", [
      `a` is the unattenuated differential flux at 1 TeV. `tau` gives optical depth. The factor `exp.(-0.8 .* tau)` attenuates each energy before migration.
    ]),
  ),
  references: (
    entry("Write the fold with named axes", [
      #code("s[.r] := M[.r, .j] * truth[.j]")
      #v(3pt)
      Here `truth` holds the three expected counts before migration. `.j` is summed and `.r` survives. This is the matrix–vector product on the reductions sheet.
    ]),
    entry("Check one detector bin", [
      The first bin receives 13.4511 counts from 0.5 TeV, 2.5564 from 1 TeV, and zero from 2 TeV. Background enters after these contributions are summed.
    ]),
    entry("Preserve losses", [
      A column sum below one assigns the remainder to events outside these detector bins. Renormalizing each column to one would redistribute those losses into the measured bins.
    ]),
    entry("Scale the exposure", [
      At fixed spectrum, doubling the observing time doubles every expected source count. Changing the flux amplitude has the same linear effect on the signal.
    ]),
  ),
)
