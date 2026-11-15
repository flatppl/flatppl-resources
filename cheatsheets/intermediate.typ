#import "theme.typ": *
#sheet(
  number: "03", title: "Hierarchical models", topic: "Intermediate",
  subtitle: "Build latent arrays, share population parameters, gather group effects, and choose a parameterization.",
  accent: rgb("3f5d6c"), file: "examples/intermediate.flatppl",
  model_title: "Grouped logistic regression",
  model_note: [Infer `mu_a`, `tau`, `z`, and `beta`. The group intercepts `a` are derived.],
  model_refs: (
    ref("Named helper and extracted graph", [
      #code("predict(a, b, x) = a .+ b .* x\nf_a = functionof(a, mu_a, tau, z)")
      Explicit boundaries define input order and close over fixed data.
    ]),
  ),
  notes: (
    (1, "Population and group variables", 11, 15, [
      Draw population parameters once. `z` contains `G` conditionally independent group variables. The affine transform constructs intercepts with conditional mean `mu_a` and scale `tau`. The slope is shared.
    ]),
    (2, "Gather by group, then broadcast", 18, 20, [
      `a[group_data]` selects one intercept per observation. Group labels lie in `1..G`. The predictor, probability and outcome arrays have one entry per observation. `invlogit` maps the predictor to success probabilities.
    ]),
    (3, "Retain the hierarchy", 23, 28, [
      Include population parameters and latent group coordinates in the prior. The kernel boundary removes their prior dependencies. All uncertainty then enters through its named inputs. The likelihood binds only the observed outcomes.
    ]),
    (4, "A point in the full latent space", 31, 33, [
      `z` must have length `G`. A point supplies every kernel input, including the hyperparameters. Scoring the likelihood excludes prior densities. Score `posterior` instead to include them.
    ]),
  ),
  refs: (
    ref("Centered alternative", [
      #code("a ~ iid(Normal(mu_a, tau), G)")
      Replace the draw of `z` and the transform of `a` with this draw. Retain `a` instead of `z` in the prior, kernel boundary and point. Do not retain both coordinate systems.
    ]),
    ref("Eight-schools observation pattern", [
      #code("theta ~ iid(Normal(mu, tau), J)\ny ~ Normal.(theta, std_errs_data)")
      Each group has one uncertain effect and a known observation error. Keep `mu`, `tau`, and `theta` in the prior and kernel interface.
    ]),
    ref("Beta–Binomial pooling", [
      #code("a_shape = phi * kappa\nb_shape = (1 - phi) * kappa\ntheta ~ iid(Beta(a_shape,b_shape), J)\ny ~ Binomial.(trials_data, theta)")
      `phi` is the population mean. Larger `kappa` concentrates group rates more tightly. Retain both hyperparameters and all group rates.
    ]),
    ref("Calling conventions", [
      #code("f(a,b) = a + b\nf(a = 1, b = 2)\nf(1, 2)\nf(record(a = 1, b = 2))")
      Explicit boundaries support positional calls. Inferred boundaries expose `elementof` leaves and support keyword calls only. Auto-splatting requires a callable that does not accept one positional input.
    ]),
    ref("Reusable modules", [
      #code("part = load_module(\"component.flatppl\")\nK_group = part.observation_kernel")
      Export reified callables and measures from the component. A caller cannot access unreified stochastic bindings. `external` inputs accept fixed substitutions at module load time.
    ]),
    ref("Shape and support checks", [
      Group labels index the latent array. Predictors and observations share length. Array ranks match and axis sizes agree or equal one. Scales stay positive. Noncentering preserves the hierarchical law.
    ]),
  ),
  takeaway: [After this sheet: author grouped and multilevel models with explicit latent interfaces.],
)
