#import "theme.typ": *

#sheet(
  topic: "Hadron physics", title: "Dalitz amplitudes", accent: rgb("894b36"),
  formula: ("Density in mass and helicity angle", [$dif P prop m q(m) k(m) abs(A)^2 dif m dif c$]),
  reference-title: "Phase space and intensity",
  file: "examples/hadron-physics.flatppl", example: "The decay D⁻ → π⁺π⁻π⁻",
  illustration: ("Interference on the Dalitz plot",
    "Three maps use the same pair-mass axes. The coherent intensity and the sum of separate intensities share a colour scale. Their signed difference has blue destructive and red constructive bands. The open circle marks the same event in each map.",
    [At `p0`, the first two maps share an intensity scale. The third shows coherent minus separate. Red marks constructive interference and blue marks destructive interference. The circles mark `event`.]),
  notes: (
    ("Pair mass and helicity angle", 9, 13, [
      Multiply the bachelor momentum by $m_D/m$ to reach the pair rest frame. There `k` is the daughter momentum. The two pairings use helicity cosines $c$ and $-c$.
    ]),
    ("Add amplitudes before squaring", 18, 21, [
      `amp` adds the two pion pairings to the unit reference amplitude. Line 23 then takes `abs2`. Squaring each term first gives `separate`. The difference includes interference with the reference and between the pairings.
    ]),
    ("Declare the two couplings", 28, 30, [
      `r` sets the common magnitude and `phi` the phase in radians. Pass both to `weight` in one record. The event coordinates on lines 26–27 are the pair mass in GeV and the helicity cosine.
    ]),
    ("Construct the event likelihood", 33, 36, [
      The Jacobian to squared-mass coordinates is $4 m q k$. `weight` uses $m q k abs(A)^2$ on `Lebesgue(support)`. The factor 4 cancels under `normalize`. Bind the observed `[m,c]` to the kernel in `r` and `phi`.
    ]),
  ),
  after-notes: (
    entry("Read the marked event", [
      #code("sp = s12(event[1], event[2])\nsm = s12(event[1], -event[2])\nu = wave(sp, p0)\nv = wave(sm, p0)")
      #v(3pt)
      `abs2(1+u+v)` gives 1.1763. `separate(u,v)` gives 1.1235. Their difference, $+0.0528$, is the interference at this event.
    ]),
  ),
  variants: (
    entry("Exchange the two negative pions", [
      #code("mirror = weight([1.0, -0.35], p0)")
      #v(3pt)
      Exchanging pions 2 and 3 takes $c$ to $-c$ and swaps $s_(12)$ with $s_(13)$. Both weights round to $0.69474017$. The invariants obey $s_(12)+s_(13)+m^2=m_D^2+3m_pi^2$.
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
      Each row is one event. For the JS engine, compute $Z$ by external quadrature. At `p0`, $Z = 1.17878135$ gives a first-event log density of $-0.52870$.
    ]),
    entry("Add background events", [
      #code("bg = joint(Uniform(interval(2*mpi, mD-mpi)),\n    Uniform(interval(-1.0, 1.0)))\nM = superpose(weighted(0.8, pdf),\n    weighted(0.2, bg))")
      #v(3pt)
      The uniform background contributes 20% of the events.
    ]),
    entry("Amplitude and resolution assumptions", [
      Zero daughter masses and $ell=0$ in `bw` give a constant width. The momenta use the pion mass. The model assumes ideal resolution. The #module-link("flatppl-amplitudes", "a522f9ef883239faf81658c763f1f4bd180b5206")[amplitudes module] gives other lineshapes and angular factors. Absolute rates require phase-space constants and a symmetry factor of $1/2$.
    ]),
  ),
)
