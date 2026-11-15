#import "theme.typ": *
#sheet(
  number: "06", title: "Hadron amplitudes and Dalitz plots", topic: "Physics",
  subtitle: "A reduced D⁻ → π⁺π⁻π⁻ model: invariant masses, Bose symmetry, coherent interference, and the phase-space measure.",
  accent: rgb("97583e"), file: "examples/hadron-physics.flatppl",
  model_title: "Bose-symmetric scalar amplitude",
  model_note: [This constant-width S-wave model omits spin tensors, barrier factors and detector resolution. The example defines a normalized shape, not an absolute decay rate.],
  notes: (
    (1, "Invariant kinematics on a rectangle", 9, 13, [
      `m` is the same-sign pair mass and `c` is its helicity-angle cosine. `s12(m,c)` is the opposite-sign pair mass squared. The other pairing is `s12(m,-c)`. All masses use GeV.
    ]),
    (2, "Coherent amplitude and identical pions", 18, 22, [
      `bw` is dimensionless and follows the denominator $m_R^2-s-i m_R Gamma$. Add both pairings before `abs2`. A constant reference amplitude interferes with the symmetrized resonance. The relative coupling is `r*cis(phi)`.
    ]),
    (3, "Support and parameter interface", 25, 29, [
      The rectangle uses $2m_pi <= m <= m_D-m_pi$ and $-1 <= c <= 1$. The fit inputs are `r` and `phi`. The coordinate array has the fixed order `[m,c]`.
    ]),
    (4, "From a density factor to a likelihood", 30, 34, [
      `weighted(f,M,p)` calls `f(x,p)`, keeping the fit parameters explicit. The weight contains phase space and amplitude intensity. Normalize before constructing the probability kernel and binding an observed event.
    ]),
  ),
  refs: (
    ref("Phase space and coordinates", [
      In these coordinates, the shape measure is proportional to $m q(m) k(m) abs(A(m,c))^2 dif m dif c$.

      The Jacobian to $(s_(23),s_(12))$ is $4m q k$. A parameter-independent constant cancels in the normalized shape. Pair masses and squared masses require different Jacobians.
    ]),
    ref("Coherent and incoherent contributions", [
      #code("coherent = abs2(A1 + A2)\nincoherent = abs2(A1) + abs2(A2)")
      The first includes interference. The second represents an incoherent sum. A probability mixture of event classes combines their measures, not their amplitudes.
    ]),
    ref("Efficiency before normalization", [
      #code("accepted(x,p) = efficiency(x) * weight(x,p)\nM_acc = normalize(weighted(accepted,\n    Lebesgue(support), parameters))")
      Efficiency multiplies the physical density inside the support. Its effect on the normalization generally depends on the amplitude parameters.
    ]),
    ref("Several observed events", [
      #code("K_events = functionof(iid(pdf,n))\nL_events = likelihoodof(K_events,data)")
      `data` is an array of `[m,c]` points and `n` is its length. Evaluate at `record(r=...,phi=...)`. A proper likelihood requires the parameter-dependent normalization.
    ]),
    ref("Symmetry and numerical checks", [
      Exchange of the two negative pions maps `c` to `-c`. The intensity is unchanged. Also verify $s_(12)+s_(13)+m^2=m_D^2+3m_pi^2$.

      At `[1,0.35]`, `r=0.6`, `phi=0.7`, the unnormalized weight is approximately $0.69474017$.
    ]),
    ref("Scope of the reduction", [
      The full example adds covariant spin factors and more resonances. The particle-physics module supplies mass-dependent widths and breakup momenta. Absolute rates require the physical constants and the identical-particle $1/2!$ factor. Normalization here needs numerical integration support.
    ]),
  ),
  takeaway: [Preserve Bose symmetry, the coordinate Jacobian, coherent phases and parameter-dependent normalization when extending the amplitude model.],
)
