#import "theme.typ": *
#sheet(
  number: "05", title: "Particle counting and spectra", topic: "Physics",
  subtitle: "Expected yields, shared detector nuisances, histogram templates, and extended unbinned observations.",
  accent: rgb("3f5d6c"), file: "examples/particle-physics.flatppl",
  model_title: "Two channels with a shared nuisance",
  model_note: [`S` is produced signal per exposure. Background rates are detected counts per exposure. The illustrative data are not an experimental analysis.],
  model_refs: (
    ref("Shared or separate nuisances", [
      #code("b_scale ~ LogNormal(0,0.2)\nb_scales ~ iid(LogNormal(0,0.2), 2)")
      A scalar nuisance is shared. An IID array assigns separate nuisance values to the channels.
    ]),
  ),
  notes: (
    (1, "A table of channel inputs", 5, 9, [
      Columns share a row count. Field access extracts whole arrays. Exposure, efficiency, background rate and observed count refer to the same channel in each row. Their units determine the yield calculation.
    ]),
    (2, "Yield construction and broadcasting", 14, 18, [
      Multiply signal production by efficiency and exposure. The scalar nuisance rescales both background rates. `Poisson.(expected)` forms independent channel counts conditional on the shared parameters.
    ]),
    (3, "Combined channel likelihood", 21, 26, [
      The observation is one record containing the count array. Its product law already combines the channels. The prior retains the signal and shared nuisance. All channels update both parameters together.
    ]),
    (4, "A numerical check point", 29, 32, [
      The parameter record gives expected counts `[4.6,10.8]`. `expected_fn(point)` uses record auto-splatting. `log_L` equals the sum of the two Poisson log densities, approximately $-3.86616$.
    ]),
  ),
  refs: (
    ref("Binned signal and background templates", [
      #code("expected = ns .* s_template .+\n    nb .* b_template\nbins ~ Poisson.(expected)")
      Unit-sum templates make `ns` and `nb` total yields. Otherwise include template normalization explicitly. Each entry denotes one disjoint bin.
    ]),
    ref("A common observation window", [
      #code("window = interval(0,10)\nsignal = normalize(truncate(\n    Normal(5,0.2), window))\nbackground = Uniform(window)")
      Normalize each component within the same selection window when its coefficient denotes the expected yield there.
    ]),
    ref("Extended unbinned model", [
      #code("I = superpose(weighted(ns,signal),\n    weighted(nb,background))\nevents ~ PoissonProcess(I)")
      The intensity mass is the expected count. The event array contains both count and position information. An additional Poisson count term for the same events would count that information twice.
    ]),
    ref("Conditional event spectrum", [
      #code("shape = normalize(I)\nenergy ~ iid(shape, n)")
      This conditions on a fixed event count. If count information is required, combine this shape term with the count model exactly once. `BinnedPoissonProcess(edges,I)` gives bin counts directly.
    ]),
    ref("Calibration and multiple likelihoods", [
      #code("L_all = joint_likelihood(L_count, L_cal)")
      Construct the calibration kernel with the same nuisance input name. Combining likelihoods multiplies densities, or adds log densities. Independent data terms may share parameters.
    ]),
    ref("Count-model choice", [
      Use Binomial counts for successes from a fixed trial total. Use Poisson counts for an expected event yield. Keep rate, exposure, acceptance and efficiency distinct. Zero expected yield assigns mass only to zero counts.
    ]),
  ),
  takeaway: [After this sheet: construct multichannel counts, binned templates and extended event models with explicit nuisance dependence.],
)
