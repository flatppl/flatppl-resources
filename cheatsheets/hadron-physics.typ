#import "theme.typ": *

#sheet(
  number: "06", topic: "Hadron physics", title: "Dalitz amplitudes", accent: rgb("894b36"),
  formula: ("Density in mass and helicity angle", [$dif P prop m q(m) k(m) abs(A)^2 dif m dif c$]),
  reference-title: "Phase space and intensity",
  file: "examples/hadron-physics.flatppl", example: "The decay D⁻ → π⁺π⁻π⁻",
  illustration: ("Dalitz intensity",
    "Intensity within the physical Dalitz boundary. Resonance bands at s12 and s13 near 0.96 GeV squared are mirror images about the diagonal.",
    [Exchanging $s_(12)$ and $s_(13)$ reflects the resonance band across the diagonal. Colour shows $abs(A)^2$ at `p0`. The constant reference amplitude alone gives one.]),
  notes: (
    ("Change kinematic coordinates", 9, 13, [
      `m` is the mass of the two negative pions. `c` is the cosine of their helicity angle. `q` and `k` give the bachelor and daughter momenta in the pair rest frame. The two opposite-sign squared masses are `s12(m,c)` and `s12(m,-c)`.
    ]),
    ("Add the amplitudes coherently", 18, 22, [
      `bw` has denominator $m_R^2-s-i m_R Gamma$. Add both pairings with the same complex coupling `p.r*cis(p.phi)` before taking `abs2`. The constant amplitude `1` provides a phase reference.
    ]),
    ("Declare coordinates and couplings", 25, 29, [
      `cartprod` defines a rectangle in `[m,c]`. The masses are in GeV and `phi` is in radians. The record passes the two fit parameters together to the density callback.
    ]),
    ("Construct the event likelihood", 30, 34, [
      `weighted` calls `weight(x, parameters)` on the Lebesgue base. `normalize` divides by the integral over the rectangle. `functionof(pdf)` exposes `r` and `phi`. The final call fixes one observed `[m,c]`.
    ]),
  ),
  after-notes: (
    entry("Change of variables", [
      The Jacobian from $(m,c)$ to $(s_(23),s_(12))$ is $4 m q k$. Its constant factor cancels from the normalized shape. In squared-mass coordinates the Dalitz density is proportional to $abs(A)^2$ across the physical region.
    ]),
  ),
  variants: (
    entry("Point and exchange checks", [
      #code("mirror = weight([1.0, -0.35], p0)")
      #v(3pt)
      Both weights round to $0.69474017$. Exchanging the negative pions sends $c$ to $-c$.
    ]),
    entry("Kinematic identity", [
      $s_(12) + s_(13) + m^2 = m_D^2 + 3 m_pi^2$. Pions 2 and 3 form the same-sign pair.
    ]),
  ),
  references: (
    entry("Include detector efficiency", [
      #code("accepted(x,p) = efficiency(x) * weight(x,p)\nM_acc = normalize(weighted(accepted,\n    Lebesgue(support), parameters))")
      #v(3pt)
      Apply efficiency inside the integral. Changing a coupling can change the accepted fraction and the normalizing integral.
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
    entry("Scope of the amplitude", [
      The example uses one constant-width S wave and ideal resolution. Spin tensors, barrier factors and mass-dependent widths enter more detailed amplitudes. Absolute rates also need the phase-space constants and the symmetry factor of one half.
    ]),
  ),
)
