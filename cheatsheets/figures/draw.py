"""Redraw the print figures from the companion FlatPPL examples."""

import ast
import re
from pathlib import Path

import matplotlib as mpl
import numpy as np

mpl.use("Agg")
import matplotlib.pyplot as plt
from matplotlib.colors import LinearSegmentedColormap, TwoSlopeNorm

HERE = Path(__file__).resolve().parent
INK = "#23362f"
MUTED = "#555f59"
RULE = "#c8cfc8"
GREEN = "#285c48"
GOLD = "#9b592c"
BLUE = "#355b76"
PLUM = "#70516f"

mpl.rcParams.update({
    "font.family": "DejaVu Sans", "font.size": 7.8, "text.color": INK,
    "axes.labelcolor": INK, "axes.edgecolor": MUTED, "axes.linewidth": 0.55,
    "axes.spines.top": False, "axes.spines.right": False, "axes.axisbelow": True,
    "xtick.color": MUTED, "ytick.color": MUTED, "xtick.major.size": 2,
    "ytick.major.size": 2, "xtick.major.width": 0.55, "ytick.major.width": 0.55,
    "xtick.major.pad": 2.5, "ytick.major.pad": 2.5, "lines.linewidth": 1.6,
    "legend.frameon": False, "legend.fontsize": 7.2, "legend.handlelength": 1.6,
    "legend.handletextpad": 0.45, "svg.hashsalt": "FlatPPL", "svg.fonttype": "path",
})


def literals(sheet, *names, record=None):
    """Read the numeric literals used in a listing or its named evaluation point."""
    source = (HERE.parent / "examples" / f"{sheet}.flatppl").read_text()
    if record:
        fields = re.search(rf"(?m)^{record} = record\(([^()]*)\)", source)
        if not fields:
            raise ValueError(f"{sheet}: missing record {record}")
        source = fields.group(1)
    values = []
    for name in names:
        match = re.search(rf"\b{name}\s*=\s*(\[[^\]\n]*\]|[-+\d.eE]+)", source)
        if not match:
            raise ValueError(f"{sheet}: missing literal {name}")
        values.append(ast.literal_eval(match.group(1)))
    return values


def axes():
    fig, ax = plt.subplots(figsize=(3.45, 1.38))
    fig.subplots_adjust(left=0.14, right=0.97, bottom=0.27, top=0.89)
    ax.grid(axis="y", color=RULE, linewidth=0.45)
    return fig, ax


def save(fig, sheet):
    svg = HERE / f"{sheet}.svg"
    fig.savefig(svg, transparent=True, dpi=330,
                metadata={"Date": None, "Creator": "FlatPPL"})
    svg.write_text(re.sub(r"[ \t]+\n", "\n", svg.read_text()))
    plt.close(fig)


def normal(x, mu: float = 0.0, sigma: float = 1.0):
    return np.exp(-0.5 * ((x - mu) / sigma) ** 2) / (np.sqrt(2 * np.pi) * sigma)


def distributions():
    fig, ax = axes()
    x = np.linspace(-3, 3, 301)
    pos = x[x >= 0]
    ax.plot(x, normal(x), color=MUTED, linestyle="--", label="standard")
    ax.plot(pos, 2 * normal(pos), color=GOLD, label="positive")
    ax.fill_between(pos, 2 * normal(pos), color=GOLD, alpha=0.09)
    ax.plot([-3, 0], [0, 0], color=GOLD, zorder=4)
    ax.set(xlim=(-3, 3), ylim=(0, 0.85), xticks=[-3, 0, 3], yticks=[0, 0.4, 0.8],
           xlabel="Value", ylabel="Density")
    ax.legend(loc="upper right", borderaxespad=0)
    save(fig, "distributions")


def beginner():
    x, y = literals("beginner", "x_data", "y_data")
    alpha, beta = literals("beginner", "alpha", "beta", record="point")
    fig, ax = axes()
    line = np.linspace(min(x), max(x), 30)
    ax.plot(line, alpha + beta * line, color=GREEN, label="fitted mean")
    ax.scatter(x, y, s=22, facecolor="white", edgecolor=INK, linewidth=1.2,
               zorder=3, label="observations")
    ax.set(xlim=(-0.16, 3.16), ylim=(0.45, 4.6), xticks=x, yticks=[1, 2, 3, 4],
           xlabel="Predictor  x", ylabel="Response  y")
    ax.legend(loc="upper left", borderaxespad=0, labelspacing=0.25)
    save(fig, "beginner")


def intermediate():
    groups, = literals("intermediate", "group_data")
    fig, ax = plt.subplots(figsize=(3.45, 1.38))
    fig.subplots_adjust(left=0.01, right=0.99, bottom=0.02, top=0.99)
    ax.set(xlim=(0.3, len(groups) + 0.7), ylim=(-0.02, 1.20))
    ax.axis("off")
    top = dict(zip(sorted(set(groups)), [1.5, 3.5, 5.5], strict=True))
    styles = ["-", "--", ":"]
    for i, g in enumerate(groups, start=1):
        ax.plot([top[g], i], [0.84, 0.34], color=BLUE, lw=1.15, ls=styles[g - 1])
        ax.text(i, 0.19, f"$a_{g}$", ha="center", va="center", color=INK, fontsize=10)
    for g, x in top.items():
        ax.text(x, 0.97, f"$a_{g}$", ha="center", va="center", color=BLUE, fontsize=12)
    ax.text(0.44, 1.12, "group intercepts", color=MUTED, fontsize=7)
    ax.text(0.44, 0.01, "observation order", color=MUTED, fontsize=7)
    save(fig, "intermediate")


def advanced():
    p, mu = literals("advanced", "p", "mu", record="point")
    fig, ax = axes()
    x = np.linspace(-3.5, 5.0, 501)
    m1 = p * normal(x, mu, 0.7)
    m2 = (1 - p) * np.maximum(x, 0) * np.exp(-np.maximum(x, 0))
    ax.plot(x, m1, color=BLUE, ls="--", lw=1.25, label=f"{p:g} Normal")
    ax.plot(x, m2, color=GOLD, ls=":", lw=1.6, label=f"{1-p:g} Gamma")
    ax.plot(x, m1 + m2, color=PLUM, label="sum")
    ax.set(xlim=(-3.5, 5), ylim=(0, 0.285), xticks=[-3, -1, 0, 2, 4], yticks=[0, 0.1, 0.2],
           xlabel="Observation  y", ylabel="Density")
    ax.legend(loc="upper right", borderaxespad=0, labelspacing=0.13)
    save(fig, "advanced")


def particle():
    exposure, efficiency, background, counts = literals(
        "particle-physics", "exposure", "efficiency", "background_rate", "counts"
    )
    production, scale = literals("particle-physics", "S", "b_scale", record="point")
    fig, ax = axes()
    signal = production * np.array(exposure) * efficiency
    bg = scale * np.array(exposure) * background
    ax.grid(False)
    ax.grid(axis="x", color=RULE, linewidth=0.45)
    ax.barh([1, 0], bg, height=0.36, color="#adc5c1", label="background")
    ax.barh([1, 0], signal, left=bg, height=0.36, color=BLUE, label="signal")
    ax.scatter(counts, [1, 0], s=24, marker="D", facecolor="white", edgecolor=INK,
               zorder=4, linewidth=0.9, label="observed")
    ax.set(xlim=(0, 12), ylim=(-0.45, 1.48), yticks=[1, 0], yticklabels=["Ch. 1", "Ch. 2"],
           xticks=[0, 4, 8, 12], xlabel="Event count")
    ax.spines["left"].set_visible(False)
    ax.tick_params(axis="y", length=0)
    fig.subplots_adjust(top=0.75)
    ax.legend(loc="lower center", ncol=3, bbox_to_anchor=(0.49, 0.99),
              columnspacing=0.75, handlelength=1)
    save(fig, "particle-physics")


def hadron():
    mpi, mD, mR, width = literals("hadron-physics", "mpi", "mD", "mR", "width")
    r, phi = literals("hadron-physics", "r", "phi", record="p0")
    low, high = (2 * mpi) ** 2, (mD - mpi) ** 2
    s = np.linspace(low, high, 501)
    s12, s13 = np.meshgrid(s, s)
    # In the (12) rest frame the opening angle ranges from 0 to pi.
    mid = (mD ** 2 + 3 * mpi ** 2 - s) / 2
    q1 = np.sqrt(np.maximum(0, s / 4 - mpi ** 2))
    q3 = np.sqrt(np.maximum(0, (mD ** 2 - s - mpi ** 2) ** 2 / (4 * s) - mpi ** 2))
    span = 2 * q1 * q3
    allowed = np.abs(s13 - mid) <= span

    def bw(si):
        return mR * width / (mR ** 2 - si - 1j * mR * width)

    intensity = np.abs(1 + r * np.exp(1j * phi) * (bw(s12) + bw(s13))) ** 2
    fig = plt.figure(figsize=(3.45, 2.10))
    ax = fig.add_axes((0.12, 0.20, 0.50, 0.76), aspect="equal")
    half_cell = (s[1] - s[0]) / 2
    palette = LinearSegmentedColormap.from_list("interference", ["#315766", "#f7f2e6", "#974029"])
    upper = np.ceil(intensity[allowed].max() * 2) / 2
    im = ax.imshow(np.ma.masked_where(~allowed, intensity), origin="lower",
                   extent=(low - half_cell, high + half_cell, low - half_cell, high + half_cell),
                   cmap=palette, norm=TwoSlopeNorm(vmin=0, vcenter=1, vmax=upper),
                   interpolation="nearest")
    ax.plot(s, mid + span, color=MUTED, lw=0.45)
    ax.plot(s, mid - span, color=MUTED, lw=0.45)
    ax.set(xlim=(0, 3.05), ylim=(0, 3.05), xticks=[0, 1, 2, 3], yticks=[0, 1, 2, 3],
           xlabel=r"$s_{12}$  [GeV²]", ylabel=r"$s_{13}$  [GeV²]")
    cax = fig.add_axes((0.71, 0.32, 0.033, 0.50))
    fig.colorbar(im, cax=cax, ticks=[0, 1, upper])
    cax.spines["outline"].set_visible(False)
    fig.text(0.69, 0.88, r"Intensity  $|A|^2$", fontsize=8)
    save(fig, "hadron-physics")


def neutrino():
    energies, baseline, trials, counts = literals(
        "neutrino-physics", "energy", "baseline", "trials", "appearance_data"
    )
    theta, dm2 = literals("neutrino-physics", "theta", "dm2", record="point")
    fig, ax = axes()
    energy = np.linspace(0.32, 1.30, 320)
    phase = 1.266932679039099 * dm2 * baseline / energy
    prob = np.sin(2 * theta) ** 2 * np.sin(phase) ** 2
    ax.plot(energy, prob, color=GREEN, label="vacuum model")
    ax.scatter(energies, np.array(counts) / trials, s=22, facecolor="white", edgecolor=INK,
               linewidth=1.1, zorder=3, label="synthetic fractions")
    ax.set(xlim=(0.30, 1.32), ylim=(0, 0.105), xticks=[0.3, 0.6, 0.9, 1.2],
           yticks=[0, 0.05, 0.1], xlabel="Energy  [GeV]", ylabel="Appearance")
    ax.legend(loc="upper right", borderaxespad=0, labelspacing=0.25)
    save(fig, "neutrino-physics")


def matrix_literal(sheet, name):
    source = (HERE.parent / "examples" / f"{sheet}.flatppl").read_text()
    match = re.search(rf"(?m)^{name} = rowstack\((\[\s*\[.*?\]\s*\])\)", source, re.S)
    if not match:
        raise ValueError(f"{sheet}: missing matrix {name}")
    return np.array(ast.literal_eval(match.group(1)))


def zero_to_hero():
    exposure, counts = literals("zero-to-hero", "exposure", "counts")
    rate, = literals("zero-to-hero", "rate", record="point")
    fig, ax = axes()
    bins = np.arange(1, len(counts) + 1)
    ax.bar(bins, rate * np.array(exposure), width=0.47, color="#a6c2b2", label="expected")
    ax.scatter(bins, counts, marker="D", s=24, facecolor="white", edgecolor=INK,
               zorder=3, label="observed")
    ax.set(xlim=(0.5, 3.5), ylim=(0, 3.8), xticks=bins,
           xticklabels=[f"{i}  (t = {t:g})" for i, t in zip(bins, exposure)],
           yticks=[0, 1, 2, 3], ylabel="Count", xlabel="Exposure interval")
    ax.legend(loc="upper left", ncol=2, columnspacing=1, borderaxespad=0)
    save(fig, "zero-to-hero")


def einstein_reductions():
    from matplotlib.patches import Rectangle

    sheet = "einstein-reductions"
    a, b = (matrix_literal(sheet, name) for name in ("A", "B"))
    fig, ax = plt.subplots(figsize=(3.45, 1.45))
    fig.subplots_adjust(left=0.01, right=0.99, top=0.97, bottom=0.03)
    ax.set(xlim=(-0.15, 10.65), ylim=(-0.1, 4.3), aspect="equal")
    ax.axis("off")
    for matrix, x, name in ((a, 0, "A"), (b, 4.15, "B"), (a @ b, 8.15, "C")):
        rows, cols = matrix.shape
        ax.text(x + cols / 2, 3.98, name, size=11, ha="center", va="center", weight="bold")
        for (i, j), value in np.ndenumerate(matrix):
            active = {"A": i == 0, "B": j == 0, "C": (i, j) == (0, 0)}[name]
            y = 1.65 + rows / 2 - i - 1
            ax.add_patch(Rectangle((x + j, y), 1, 1, fc="#d6e6e4" if active else "white",
                                   ec=BLUE if active else RULE, lw=0.9 if active else 0.45))
            ax.text(x + j + 0.5, y + 0.5, str(value), ha="center", va="center",
                    weight="bold" if active else "normal", color=BLUE if active else MUTED, size=9)
    for x, symbol in ((3.58, "×"), (7.08, "=")):
        ax.text(x, 1.65, symbol, ha="center", va="center", size=13)
    save(fig, sheet)


def metric_einstein():
    from matplotlib.patches import Arc

    sheet = "metric-einstein"
    basis = np.linalg.cholesky(np.linalg.inv(matrix_literal(sheet, "g"))).T
    u, v = (basis @ coords for coords in literals(sheet, "u", "v"))
    fig, ax = plt.subplots(figsize=(3.45, 1.8))
    fig.subplots_adjust(left=0.06, right=0.98, top=0.94, bottom=0.09)
    ax.set(aspect="equal", xlim=(-0.25, 3.65), ylim=(-0.26, 2.32))
    ax.axis("off")
    for i in range(-3, 5):
        for j in (0, 1):
            ends = [basis[:, j] * i + basis[:, 1-j] * k for k in (-4, 5)]
            ax.plot(*np.array(ends).T, color=RULE, lw=0.5, zorder=0)
    for name, vector, colour in (("u", u, BLUE), ("v", v, PLUM)):
        ax.annotate("", xy=vector, xytext=(0, 0),
                    arrowprops=dict(arrowstyle="-|>", color=colour, lw=1.8, shrinkA=0, shrinkB=0))
        ax.text(*(vector + [0.06, 0.10]), name, color=colour, size=12, style="italic")
    for i, label in enumerate(("$e_1$", "$e_2$")):
        end = basis[:, i]
        ax.annotate("", xy=end, xytext=(0, 0),
                    arrowprops=dict(arrowstyle="->", lw=0.9, color=MUTED, shrinkA=0, shrinkB=0))
        ax.text(end[0] + 0.05, end[1] - 0.13, label, color=MUTED, size=8)
    angles = np.degrees([np.arctan2(vec[1], vec[0]) for vec in (u, v)])
    ax.add_patch(Arc((0, 0), 1.25, 1.25, theta1=angles[0], theta2=angles[1], color=INK, lw=0.75))
    ax.text(0.49, 0.43, f"{np.diff(angles).item():.0f}°", size=8, color=INK,
            bbox=dict(facecolor="white", edgecolor="none", pad=0.4))
    save(fig, sheet)


def posterior_prediction():
    from statistics import NormalDist

    sheet = "posterior-prediction"
    x, y, sigma = literals(sheet, "x", "y", "sigma")
    design = np.column_stack((np.ones(len(x)), x))
    cov = np.linalg.inv(np.diag([1/25, 1/4]) + design.T @ design / sigma**2)
    mean = cov @ design.T @ y / sigma**2
    grid = np.linspace(-0.45, 3.45, 151)
    h = np.column_stack((np.ones_like(grid), grid))
    line = h @ mean
    v_mean = np.einsum("ij,jk,ik->i", h, cov, h)
    z = NormalDist().inv_cdf(0.95)
    fig, ax = axes()
    for variance, colour, name in ((v_mean + sigma**2, "#d8e4e9", "new reading"),
                                    (v_mean, "#9bbda7", "mean")):
        width = z * np.sqrt(variance)
        ax.fill_between(grid, line-width, line+width, color=colour, label=name)
    ax.plot(grid, line, color=GREEN, lw=1)
    ax.scatter(x, y, facecolor="white", edgecolor=INK, s=16, zorder=4)
    x_new, = literals(sheet, "x_new")
    ax.axvline(x_new, ls=":", lw=0.8, color=MUTED)
    ax.set(xlim=(grid[0], grid[-1]), xticks=x, yticks=[0, 2, 4, 6],
           xlabel="Predictor  x", ylabel="Response")
    ax.legend(loc="upper left", borderaxespad=0.1)
    save(fig, sheet)


def fitting_from_python():
    path = HERE.parent / "examples" / "fit.py"
    tree = ast.parse(path.read_text())
    declaration = next(node for node in tree.body if isinstance(node, ast.Assign)
                       and node.targets[0].id == "data")
    y = np.array(ast.literal_eval(declaration.value.args[0]))
    mu_hat, tau_hat = y.mean(), 1 / y.var()
    mu, tau = np.meshgrid(np.linspace(0.42, 1.88, 161), np.linspace(0.18, 8.0, 171))
    loss = 0.5 * len(y) * (tau / tau_hat - 1 - np.log(tau / tau_hat)
                            + tau * (mu - mu_hat)**2)
    fig, ax = axes()
    levels = [0.5, 1, 2, 4]
    ax.contourf(mu, tau, loss, levels=[0, *levels], colors=["#c0d5d1", "#d8e5de", "#e3ede6", "#f2f5ef"])
    contours = ax.contour(mu, tau, loss, levels=levels, colors=BLUE, linewidths=0.75)
    ax.clabel(contours, fmt="%g", fontsize=6.6, inline=True)
    ax.plot(mu_hat, tau_hat, marker="+", color=INK, ms=8, mew=1.5)
    ax.set(xlabel="Mean  μ", ylabel="Precision  τ", yticks=[1, 3, 5, 7])
    save(fig, "fitting-from-python")


def measurement():
    sheet = "measurement"
    lo, hi, cut = literals(sheet, "lo", "hi", "cut")
    x = np.linspace(0.25, 1.96, 1000)
    fig, axes_pair = plt.subplots(2, 1, figsize=(3.45, 1.80), sharex=True)
    fig.subplots_adjust(left=0.06, right=0.97, bottom=0.25, top=0.95, hspace=0.20)
    for ax, sd, low, high, colour, label in (
        (axes_pair[0], 0.2, lo, hi, BLUE, "rounded to 1.0"),
        (axes_pair[1], 0.3, cut, x[-1], GOLD, "above 1.20"),
    ):
        density = normal(x, 1.0, sd)
        ax.fill_between(x, 0, density, where=(x >= low) & (x <= high), color=colour, alpha=0.45)
        ax.plot(x, density, color=colour, lw=1)
        ax.text(0.0, 0.80, label, transform=ax.transAxes, color=colour, fontsize=7)
        ax.set(yticks=[], xlim=(x[0], x[-1]), ylim=(0, max(density)*1.18))
        ax.spines["left"].set_visible(False)
    axes_pair[1].set(xlabel="Latent instrument reading", xticks=[0.5, 1, 1.2, 1.5])
    save(fig, sheet)


def profile_marginal():
    from math import lgamma

    sheet = "profile-marginal"
    n, m, ratio, shape, rate = literals(sheet, "n", "m", "ratio", "shape", "rate")
    s = np.linspace(0, 13, 401)
    b = np.linspace(0.005, 15, 1001)[:, None]
    joint_log = n*np.log(s+b) - s-b + m*np.log(ratio*b) - ratio*b - lgamma(n+1) - lgamma(m+1)
    log_prior = shape*np.log(rate) - lgamma(shape) + (shape-1)*np.log(b) - rate*b
    density = np.exp(joint_log + log_prior)
    marginal = np.log(np.sum((density[1:] + density[:-1]) * np.diff(b, axis=0)/2, axis=0))
    profile = joint_log.max(axis=0)
    fig, (surface, scan) = plt.subplots(2, 1, figsize=(3.45, 2.25), sharex=True)
    fig.subplots_adjust(left=0.18, right=0.97, bottom=0.17, top=0.95, hspace=0.21)
    drop = joint_log.max() - joint_log
    surface.contourf(s, b[:, 0], drop, levels=[0, 0.5, 2, 4, 8],
                     colors=["#cedfd7", "#e2eae1", "#eff2ec", "#f7f8f3"])
    surface.contour(s, b[:, 0], drop, levels=[0.5, 2, 4, 8], colors=MUTED, linewidths=0.45)
    surface.plot(s, b[joint_log.argmax(axis=0), 0], color=PLUM, lw=1, label="best background")
    surface.plot(n-m/ratio, m/ratio, marker="+", color=INK, ms=6)
    surface.set(ylim=(0.25, 5.5), yticks=[1, 3, 5], ylabel="Background")
    surface.legend(loc="upper right", borderaxespad=0, fontsize=6.5, frameon=True,
                   facecolor="white", edgecolor="none", framealpha=0.95, borderpad=0.2)
    scan.plot(s, profile-profile.max(), color=PLUM, label="profile")
    scan.plot(s, marginal-marginal.max(), color=GOLD, ls="--", label="Gamma marginal")
    scan.set(xlim=(0, 13), ylim=(-4, 0.24), xticks=[0, 3, 6, 9, 12], yticks=[-4, -2, 0],
             xlabel="Expected signal count", ylabel="Relative log L")
    scan.legend(loc="lower left", ncol=2, columnspacing=0.8, borderaxespad=0, fontsize=6.5)
    save(fig, sheet)


def gamma_ray_response():
    sheet = "gamma-ray-response"
    energy, width, area, depth, exposure, amplitude = literals(
        sheet, "E", "width", "area", "tau", "time", "amplitude")
    response = matrix_literal(sheet, "M")
    truth = exposure * np.array(area) * width * amplitude * np.array(energy)**-2 * np.exp(-0.8*np.array(depth))
    parts = np.vstack([response, 1-response.sum(axis=0)]) * truth
    fig, ax = axes()
    fig.subplots_adjust(left=0.20, top=0.78)
    totals = np.zeros(parts.shape[0])
    for i, colour in enumerate((BLUE, "#a8c2b3", GOLD)):
        ax.barh([2, 1, 0], parts[:, i], left=totals, color=colour, height=0.50, label=f"{energy[i]:g} TeV")
        totals += parts[:, i]
    ax.set(yticks=[2, 1, 0], yticklabels=["Bin 1", "Bin 2", "Lost"], xlim=(0, 18),
           xlabel="Expected source counts", xticks=[0, 4, 8, 12, 16])
    ax.grid(False)
    ax.grid(axis="x", color=RULE, lw=0.45)
    ax.legend(ncol=3, loc="lower center", bbox_to_anchor=(0.46, 0.99), columnspacing=0.8)
    save(fig, sheet)


def decay_ode():
    sheet = "decay-ode"
    readings, = literals(sheet, "y_data")
    grid = np.linspace(0, 1, 11)
    times = grid[[0, 5, 10]]
    x = np.linspace(0, 1, 151)
    fig, ax = axes()
    ax.plot(x, np.exp(-x), color=GREEN, label="exact")
    ax.scatter(grid, np.exp(-grid), s=12, facecolor="white", edgecolor=GREEN,
               lw=0.65, zorder=3, label="grid")
    ax.errorbar(times, readings, yerr=0.05, fmt="D", color=GOLD, ms=3.2,
                lw=0.8, capsize=2.2, zorder=4, label="observed")
    ax.set(xlim=(-0.04, 1.04), xticks=[0, 0.5, 1], yticks=[0.4, 0.7, 1.0],
           xlabel="Time", ylabel="State")
    ax.legend(ncol=3, loc="upper right", handlelength=1, columnspacing=0.7, borderaxespad=0)
    save(fig, sheet)


def two_spins():
    ratio, = literals("two-spins", "ratio")
    spins = np.array(literals("two-spins", "pp", "pm", "mp", "mm"))
    bond = spins.prod(axis=1)
    positions = np.arange(len(bond))
    fig, ax = axes()
    for coupling, shift, colour, label in (
        (0, -0.15, "#b8c6c3", "K = 0"), (np.log(ratio)/2, 0.15, GOLD, "K = log(3)/2"),
    ):
        weights = np.exp(coupling * bond)
        ax.bar(positions + shift, weights/weights.sum(), width=0.28, color=colour, label=label)
    ax.set(xticks=positions, xticklabels=["++", "+−", "−+", "−−"], yticks=[0, 0.25, 0.5],
           ylim=(0, 0.52), xlabel="Ordered spin pair", ylabel="Probability")
    ax.legend(loc="upper center", ncol=2, borderaxespad=0, columnspacing=1.0)
    save(fig, "two-spins")


if __name__ == "__main__":
    for draw in (zero_to_hero, distributions, beginner, intermediate, advanced, einstein_reductions,
                 metric_einstein, posterior_prediction, fitting_from_python, measurement,
                 profile_marginal, particle, hadron, neutrino, gamma_ray_response, decay_ode, two_spins):
        draw()
