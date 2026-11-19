import { createHash } from "node:crypto";
import { cp, mkdir, readFile, writeFile } from "node:fs/promises";
import { resolve } from "node:path";
import { spawnSync } from "node:child_process";

const root = resolve(import.meta.dirname, "..");
const theme = process.env.FLATPPL_THEME_DIR ?? resolve(root, "../flatppl-theme");
const output = resolve(root, "build/gallery");
const stylesheet = await readFile(resolve(import.meta.dirname, "gallery.css"));
const stylesheetRevision = createHash("sha256").update(stylesheet).digest("hex").slice(0, 12);
const sheets = (await readFile(resolve(root, "cheatsheets/sheets.txt"), "utf8")).trim().split(/\s+/);
const readme = await readFile(resolve(root, "README.md"), "utf8");
const rows = readme.matchAll(/^\| \[([^\]]+)\]\([^\s)]+\/([\w-]+)\.pdf\) \| ([^|]+) \|$/gm);
const metadata = new Map([...rows].map(([, title, id, description]) => [id, { title, description: description.trim() }]));
const topics = [
  { id: "language", title: "Core language", sheets: [
    "zero-to-hero", "beginner", "intermediate", "advanced", "distributions",
    "einstein-reductions", "metric-einstein",
  ] },
  { id: "modelling", title: "Modelling and inference", sheets: [
    "formula-api", "regression-module", "posterior-prediction", "fitting-from-python",
    "measurement", "profile-marginal",
  ] },
  { id: "applications", title: "Physics and applications", sheets: [
    "particle-physics", "hadron-physics", "neutrino-physics", "gamma-ray-response",
    "decay-ode", "two-spins",
  ] },
  { id: "tools", title: "Tools", sheets: ["python-sdk", "cli"] },
];

const gallerySheets = topics.flatMap(topic => topic.sheets);
if ([...sheets].sort().join() !== gallerySheets.sort().join()) {
  throw new Error("Assign each entry in cheatsheets/sheets.txt to one gallery topic.");
}
for (const id of sheets) {
  if (!metadata.has(id)) throw new Error(`Missing gallery title and description for ${id} in README.md.`);
}

const escape = value => value.replace(/[&<>"]/g, char => ({
  "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;",
})[char]);
const header = (await readFile(resolve(theme, "header.html"), "utf8"))
  .replace('data-fp-nav="learn"', 'data-fp-nav="learn" aria-current="page"');
const footer = await readFile(resolve(theme, "footer.html"), "utf8");

function renderCard(id) {
  const { title, description } = metadata.get(id);
  const loading = topics[0].sheets.slice(0, 4).includes(id) ? "eager" : "lazy";
  return `<li>
  <a class="sheet-card" href="pdf/${id}.pdf" aria-labelledby="title-${id} format-${id}" aria-describedby="description-${id}">
    <div class="sheet-preview">
      <img src="previews/${id}.jpg" width="720" height="510" loading="${loading}" decoding="async" alt="">
    </div>
    <div class="sheet-caption">
      <div class="sheet-label">
        <h3 id="title-${id}">${escape(title)}</h3>
        <span class="sheet-format" id="format-${id}">PDF</span>
      </div>
      <p id="description-${id}">${escape(description)}.</p>
    </div>
  </a>
</li>`;
}

const sections = topics.map(topic => `<section class="topic" aria-labelledby="${topic.id}">
  <div class="topic-heading"><h2 id="${topic.id}">${topic.title}</h2></div>
  <ul class="sheet-grid">
    ${topic.sheets.map(renderCard).join("\n")}
  </ul>
</section>`).join("\n");

const page = `<!doctype html>
<html lang="en" data-fp-active="learn">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="description" content="One-page references for the FlatPPL language, modelling, and tools.">
  <title>Cheatsheets · FlatPPL</title>
  <link rel="icon" href="theme/assets/favicon.svg" type="image/svg+xml">
  <link rel="stylesheet" href="theme/tokens.css">
  <link rel="stylesheet" href="theme/components.css">
  <link rel="stylesheet" href="theme/shell.css">
  <link rel="stylesheet" href="gallery.css?v=${stylesheetRevision}">
  <script src="theme/shell.js"></script>
</head>
<body>
${header}
<main id="main-content" tabindex="-1">
  <div class="gallery-intro">
    <h1>Cheatsheets</h1>
    <p>One-page references for the FlatPPL language, modelling, and tools.</p>
    <nav class="topic-nav" aria-label="Cheatsheet topics">
      <ul>${topics.map(({ id, title }) => `<li><a class="fp-btn" href="#${id}">${title}</a></li>`).join("")}</ul>
    </nav>
  </div>
  ${sections}
</main>
${footer}
</body>
</html>
`;

await mkdir(resolve(output, "theme/assets"), { recursive: true });
await mkdir(resolve(output, "pdf"), { recursive: true });
await mkdir(resolve(output, "previews"), { recursive: true });
for (const file of ["tokens.css", "components.css", "shell.css", "shell.js", "assets/logo.svg", "assets/favicon.svg", "LICENSE.md", "LICENSES"]) {
  await cp(resolve(theme, file), resolve(output, "theme", file), { recursive: true });
}
await writeFile(resolve(output, "gallery.css"), stylesheet);
for (const id of sheets) {
  const pdf = resolve(root, "build/cheatsheets", `${id}.pdf`);
  await cp(pdf, resolve(output, "pdf", `${id}.pdf`));
  const render = spawnSync("pdftoppm", [
    "-singlefile", "-scale-to", "720", "-jpeg", "-jpegopt", "quality=85,optimize=y",
    pdf, resolve(output, "previews", id),
  ], { stdio: "inherit" });
  if (render.error) throw render.error;
  if (render.status !== 0) throw new Error(`Could not render a preview for ${id}.`);
}
await writeFile(resolve(output, "index.html"), page);
console.log(`Built ${sheets.length} sheets in ${output}.`);
