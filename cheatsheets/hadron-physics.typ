#import "theme.typ": *

#sheet(
  topic: "Hadron physics", title: "Dalitz amplitudes", accent: rgb("894b36"),
  formula: ("Density in mass and helicity angle", [$dif P prop m q(m) k(m) abs(A)^2 dif m dif c$]),
  reference-title: "Phase space and intensity",
  file: "examples/hadron-physics.flatppl", example: "The decay D⁻ → π⁺π⁻π⁻",
  illustration: ("Dalitz intensity",
    "Intensity within the physical Dalitz boundary. Resonance bands at s12 and s13 near 0.96 GeV squared are mirror images about the diagonal.",
    [Exchanging $s_(12)$ and $s_(13)$ reflects the resonance band across the diagonal. Colour shows $abs(A)^2$ at `p0`. The constant reference amplitude alone gives one.]),
  notes: (
    ("Pair mass and helicity angle", 9, 13, [
      Use the mass `m` of the two negative pions and the cosine `c` of their helicity angle. In the pair rest frame, `q` and `k` are the bachelor and daughter momenta. The opposite-sign squared masses are `s12(m,c)` and `s12(m,-c)`.
    ]),
    ("Bose-symmetric amplitude", 18, 22, [
      The Breit–Wigner denominator is $m_R^2-s-i m_R Gamma$. Give both pairings the same complex coupling `p.r*cis(p.phi)`. Sum their amplitudes and the constant phase reference `1` before applying `abs2`.
    ]),
    ("Declare coordinates and couplings", 25, 29, [
      Define the `[m,c]` rectangle with `cartprod`. Express the masses in GeV and `phi` in radians. Pass both fit parameters to the density callback in one record.
    ]),
    ("Construct the event likelihood", 30, 34, [
      On the Lebesgue base, `weighted` evaluates `weight(x, parameters)`. Normalize by the integral over the rectangle. `functionof(pdf)` takes `r` and `phi`. Bind one observed `[m,c]` to obtain the event likelihood.
    ]),
  ),
  after-notes: (
    entry("Change of variables", [
      The Jacobian from $(m,c)$ to $(s_(23),s_(12))$ is $4 m q k$. Its constant factor cancels from the normalized shape. In squared-mass coordinates the Dalitz density is proportional to $abs(A)^2$ across the physical region.
    ]),
  ),
  variants: (
    entry("Pion exchange", [
      #code("mirror = weight([1.0, -0.35], p0)")
      #v(3pt)
      Exchanging the negative pions takes $c$ to $-c$. Both weights round to $0.69474017$.
    ]),
    entry("Kinematic identity", [
      $s_(12) + s_(13) + m^2 = m_D^2 + 3 m_pi^2$. Pions 2 and 3 form the same-sign pair.
    ]),
  ),
  references: (
    entry("Include detector efficiency", [
      #code("accepted(x,p) = efficiency(x) * weight(x,p)\nM_acc = normalize(weighted(accepted,\n    Lebesgue(support), parameters))")
      #v(3pt)
      Include the efficiency in the integrand. A change in coupling can alter both the accepted fraction and the normalization integral.
    ]),
    entry("Bind several events", [
      #code("K_events = functionof(iid(pdf, n))\nL_events = likelihoodof(K_events, data)")
      #v(3pt)
      Supply `n` event pairs in `data`. A normalized score for this model requires numerical integration at the chosen parameter values.
    ]),
    entry("Add background events", [
      #code("M = superpose(weighted(f, pdf),\n    weighted(1 - f, background))")
      #v(3pt)
      For a signal fraction `f` and a normalized background on the same coordinates, add their measures. Interference belongs inside the signal amplitude.
    ]),
    entry("Amplitude and resolution assumptions", [
      The model assumes one constant-width S wave and ideal resolution. The #module-link("flatppl-amplitudes", "a522f9ef883239faf81658c763f1f4bd180b5206")[amplitudes module] provides additional lineshapes and angular factors. Absolute rates also require the phase-space constants and the symmetry factor of one half.
    ]),
  ),
)
