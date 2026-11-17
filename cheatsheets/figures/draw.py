"""Redraw the seven print figures from the companion FlatPPL examples."""

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


if __name__ == "__main__":
    for draw in (distributions, beginner, intermediate, advanced, particle, hadron, neutrino):
        draw()
