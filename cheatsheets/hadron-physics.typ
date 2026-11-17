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
      Let `m` be the negative-pion pair mass and `c` its helicity-angle cosine. In that frame, `q` and `k` are the bachelor and daughter momenta. The opposite-sign masses squared are `s12(m,c)` and `s12(m,-c)`.
    ]),
    ("Bose-symmetric amplitude", 18, 22, [
      The Breit–Wigner denominator is $m_R^2-s-i m_R Gamma$. Both pairings have coupling `p.r*cis(p.phi)`. Add both amplitudes to the phase reference `1` before applying `abs2`.
    ]),
    ("Declare coordinates and couplings", 25, 29, [
      Use `cartprod` for the `[m,c]` rectangle. Masses are in GeV and `phi` in radians. The density callback takes both fit parameters in one record.
    ]),
    ("Construct the event likelihood", 30, 34, [
      On the Lebesgue base, `weighted` evaluates `weight(x, parameters)`. Normalize by the integral over the rectangle. `functionof(pdf)` takes `r` and `phi`. Bind one observed `[m,c]` to obtain the event likelihood.
    ]),
  ),
  after-notes: (
    entry("Change of variables", [
      The Jacobian from $(m,c)$ to $(s_(23),s_(12))$ is $4 m q k$. The factor 4 cancels on normalization. In squared-mass coordinates the density is proportional to $abs(A)^2$ on the physical region.
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
      #code("eff(c) = 1 - 0.2*c^2\naccepted(x,p) = eff(x[2]) * weight(x,p)\nM_acc = normalize(weighted(accepted,\n    Lebesgue(support), parameters))")
      #v(3pt)
      This angular efficiency ranges from 0.8 to 1. Include it in the normalization integral at each coupling.
    ]),
    entry("Bind several events", [
      #code("data = [[1.0, 0.35], [0.9, -0.2]]\nK_events = functionof(iid(pdf, 2))\nL_events = likelihoodof(K_events, data)")
      #v(3pt)
      Each row is one event. The normalized score requires numerical integration at the chosen couplings.
    ]),
    entry("Add background events", [
      #code("bg = normalize(Lebesgue(support))\nM = superpose(weighted(0.8, pdf),\n    weighted(0.2, bg))")
      #v(3pt)
      Add a 20% background uniform in $(m,c)$. Interference belongs inside the signal amplitude.
    ]),
    entry("Amplitude and resolution assumptions", [
      The model assumes one constant-width S wave and ideal resolution. The #module-link("flatppl-amplitudes", "a522f9ef883239faf81658c763f1f4bd180b5206")[amplitudes module] provides additional lineshapes and angular factors. Absolute rates also require the phase-space constants and the symmetry factor of one half.
    ]),
  ),
)
