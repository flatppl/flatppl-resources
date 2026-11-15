#import "theme.typ": *

#sheet(
  number: "03", title: "Intermediate / modelling", topic: "Hierarchies and reuse",
  subtitle: "Share information across groups and extract reusable graph fragments. Assumes the beginner sheet.",
  accent: rgb("3f5d6c"), file: "examples/intermediate.flatppl",
  model_title: "Partial pooling of group rates",
  model_note: [Each group has its own rate. All group rates share uncertain population parameters. The observed sample sizes differ.],
  notes: (
    (1, "Expose useful parameters", 9, 15, [
      `phi` is the population mean. `kappa` is the concentration. The helper converts them to Beta shapes and returns a record that auto-splats into `Beta`.
    ]),
    (2, "Share through the graph", 18, 19, [
      `theta` has `J` entries. They are IID *given* `phi` and `kappa`. The Binomial broadcast pairs each entry with its group's trial count.
    ]),
    (3, "Extract a function", 31, 33, [
      `functionof` cuts the graph at `phi` and `kappa`, naming its inputs `m` and `k`. The result here is `record(alpha = 3, beta = 7)`.
    ]),
  ),
  refs: (
    ref("What controls pooling?", [
      The population has mean $phi$ and variance $phi (1 - phi) / (kappa + 1)$.

      Larger `kappa` concentrates group rates near `phi`. At fixed population parameters, more observations give a group's own data more weight.
    ]),
    ref("Choose the right reification", [
      #code("lawof(theta)\nfunctionof(expr, m = phi, k = kappa)\nkernelof(y, phi, kappa, theta)")
      `lawof` makes a law. `functionof` makes a deterministic callable here. `kernelof` makes a probability kernel with the chosen inputs.
    ]),
    ref("Keep the full parameter interface", [
      Lines 22–26 retain both population and group parameters. The observation kernel depends on `theta` only, but accepts `phi` and `kappa` too.

      Explicit boundaries replace each chosen node with an independent input. They remove the original dependencies between those inputs.
    ]),
    ref("Separate files", [
      #code("part = load_module(\"population.flatppl\")\nhelper = part.shapes")
      Use public functions, kernels, and measures from a loaded module. Reify its stochastic values inside that module before export.
    ]),
    ref("Track array shapes", [
      `theta`, `trials_data`, and `hits_data` all have length `J`. Scalars broadcast. Array ranks must match, with equal or singleton axis sizes.
    ]),
  ),
  takeaway: [*Reuse a graph:* write a fresh helper with `f(x) = expr`. Extract an existing calculation with `functionof`. Extract a stochastic model with `kernelof`.],
  sources: "Spec: Named functions · Calling conventions · Reification boundaries · Broadcasting",
)
