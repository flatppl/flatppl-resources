#import "theme.typ": *

#sheet(
  topic: "Particle physics", title: "Counting experiments", accent: rgb("355b76"),
  formula: ("Expected yield in channel j", [$lambda_j = T_j (b rho_j + epsilon_j S)$]),
  reference-title: "Counts and spectra",
  file: "examples/particle-physics.flatppl", example: "Two channels, one background scale",
  illustration: ("Expected and observed counts",
    "Channel one has 3 background and 1.6 signal events expected, with 5 observed. Channel two has 8 and 2.8 expected, with 10 observed.",
    [For `S = 2` and `b_scale = 1` the means are 4.6 and 10.8. The diamonds mark the synthetic counts supplied in `channels.counts`.]),
  notes: (
    ("Channel data as a table", 5, 9, [
      Store one channel per row. Field access such as `channels.exposure` returns a column. Multiply production by exposure and efficiency to obtain the expected count.
    ]),
    ("Broadcast the yield equation", 14, 18, [
      Both background rates share `b_scale`. Efficiency acts on the produced signal `S`. Given these parameters, `Poisson.` draws the two channel counts independently.
    ]),
    ("Observed counts and parameter names", 21, 26, [
      Name both `S` and `b_scale` in the prior and the kernel inputs. The observation record needs one field, `counts`, containing the vector of channel counts.
    ]),
    ("The two-channel log likelihood", 29, 32, [
      Evaluate the expected counts with `functionof` at the parameter point used by `logdensityof`. The sum of the two Poisson log masses gives `log_L` $approx -3.86616$.
    ]),
  ),
  after-notes: (
    entry("A calibration constraint", [
      #code("cal(b) = logdensityof(Normal(b, 0.1), 1.05)\ncombined = log_L + cal(point.b_scale)")
      #v(3pt)
      An independent calibration reads 1.05 with standard deviation 0.1. Add its log density at the same background scale.
    ]),
  ),
  variants: (
    entry("Independent channel uncertainties", [
      #code("b_scales ~ iid(LogNormal(0, 0.2), 2)")
      #v(3pt)
      For independent background scales draw a two-element vector. Replace the scalar in the prediction, prior, kernel inputs and parameter record.
    ]),
    entry("A histogram with two templates", [
      #code("means = 4 .* [0.3, 0.7] .+ 11 .* [0.4, 0.6]\nbins ~ Poisson.(means)")
      #v(3pt)
      Each template sums to one. The signal yield 4 and background yield 11 give bin means 5.6 and 9.4.
    ]),
  ),
  references: (
    entry("Define the observation window", [
      #code("window = interval(0, 10)\npeak = normalize(truncate(\n    Normal(5, 0.2), window))\ncontinuum = Uniform(window)")
      #v(3pt)
      Normalize the shapes on the same window when their coefficients give the expected yields there.
    ]),
    entry("Unbinned event likelihood", [
      #code("I = superpose(weighted(4, peak),\n    weighted(11, continuum))\nevents ~ PoissonProcess(I)")
      #v(3pt)
      The total intensity gives the expected count. The event array specifies both the energies and their number. Its likelihood therefore contains the count term.
    ]),
    entry("Condition on the event count", [
      #code("shape = normalize(I)\nenergy ~ iid(shape, 15)")
      #v(3pt)
      Fixing the count at 15 leaves the energy shape. For counts in two energy bins, use `BinnedPoissonProcess([0,5,10], I)`.
    ]),
    entry("Fixed trial totals", [
      #code("passed ~ Binomial(20, channels.efficiency[1])")
      #v(3pt)
      Use a Binomial law when the trial total is known. A Poisson yield describes a random count over a fixed exposure.
    ]),
  ),
)
