#import "theme.typ": *

#sheet(
  number: "03", title: "Functions and reification", topic: "Intermediate",
  subtitle: "Named functions, inferred inputs, explicit graph boundaries, and callable interfaces.",
  accent: rgb("3f5d6c"), file: "examples/intermediate.flatppl",
  model_title: "Reifying a deterministic and stochastic graph",
  model_note: [Reification turns an existing graph fragment into a callable or measure. Explicit boundaries determine where the ancestor trace stops.],
  notes: (
    (1, "Named functions", 11, 12, [
      `affine(a, b, x) = expr` binds a single-expression function. Its argument names are local. Dotted operators apply the arithmetic elementwise.
    ]),
    (2, "Function boundaries", 15, 18, [
      `f_auto` exposes the parametric leaves `alpha` and `beta`. `f` instead declares inputs `a` and `b`. Both close over `x_data`. The record auto-splats into `f`.
    ]),
    (3, "Kernel boundaries", 21, 24, [
      `kernelof` reifies the stochastic graph below `alpha` and `beta` as a kernel with inputs `a` and `b`. Its output and the observed data both have a field named `y`.
    ]),
  ),
  refs: (
    ref("Reification operations", [
      #code("lawof(y)\nfunctionof(mu, a = alpha, b = beta)\nkernelof(y, a = alpha, b = beta)")
      `lawof` returns the law of a value. `functionof` returns a function, or a kernel for a measure-valued expression. `kernelof` reifies a value as a probability kernel.
    ]),
    ref("Calling conventions", [
      #code("f(a = 1, b = 2)\nf(1, 2)\nf(record(a = 1, b = 2))")
      Explicit boundaries define positional order. An inferred boundary supports keyword calls only. Record auto-splatting applies when the callable does not accept a lone positional argument.
    ]),
    ref("Boundary semantics", [
      Boundaries replace the designated nodes with independent inputs before the ancestor trace. The input names belong to the new callable.

      Boundary lists are all explicit or all inferred. Explicit lists may use bare names, as in `functionof(mu, alpha, beta)`.
    ]),
    ref("Modules and external inputs", [
      #code("# component.flatppl\nn = external(posintegers)\nmeasure = iid(Normal(0, 1), n)")
      #v(5pt)
      #code("# caller.flatppl\npart = load_module(\"component.flatppl\",\n    n = 3)\nM = part.measure")
      `external` declares a module input fixed at load time. Loaded modules expose fixed and parametric public bindings, including reified measures and callables.
    ]),
    ref("Broadcast shapes", [
      Scalars remain constant during broadcasting. Collection operands require equal rank. Corresponding axis sizes must agree or equal one.
    ]),
  ),
  takeaway: [*Boundary notation:* `functionof(expr, alpha, beta)` abbreviates `functionof(expr, alpha = alpha, beta = beta)`. The same notation applies to `kernelof`.],
  sources: "Specification: Named functions · Calling conventions · Reification to functions and kernels · Module composition",
)
