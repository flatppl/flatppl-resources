#let ink = rgb("23342d")
#let secondary = rgb("4e5a54")
#let rule = rgb("c4cec5")
#let serif = ("Libertinus Serif", "STIX Two Text")
#let sans = ("Helvetica Neue", "Arial")
#let mono = ("DejaVu Sans Mono", "Menlo")
#let letters = ("A", "B", "C", "D")
#let column-height = 492pt

#let label(body, fill: secondary) = text(
  font: sans, size: 7.2pt, weight: "bold", tracking: 0.85pt, fill: fill, upper(body),
)
#let subhead(body, size: 12pt) = text(font: serif, size: size, weight: "bold", fill: ink, body)
#let hairline = line(length: 100%, stroke: 0.5pt + rule)

// Typst normally scales raw text down. Set the printed size on the raw element.
#let highlighted(source, size) = {
  show raw: set text(font: mono, size: size)
  set par(leading: 2.0pt, spacing: 0pt)
  raw(source, block: true, lang: "flatppl",
    syntaxes: "syntax/flatppl.sublime-syntax", theme: "syntax/flatppl.tmTheme")
}

#let check-width(source, size, available) = {
  let longest = source.split("\n").sorted(key: s => s.len()).last()
  let needed = measure(text(font: mono, size: size, longest)).width
  assert(needed <= available, message: "Code exceeds column width: " + longest)
}

#let code(source, size: 8pt) = layout(region => context {
  check-width(source, size, region.width)
  highlighted(source, size)
})

#let entry(title, body) = block(width: 100%, breakable: false)[
  #hairline
  #v(4pt)
  #subhead(title, size: 11.7pt)
  #v(4.7pt)
  #body
]

#let marker(letter, accent, size: 12pt) = box(width: size, height: size,
  radius: size/2, fill: accent, align(center + horizon,
    text(font: sans, size: size * 0.66, weight: "bold", fill: white, letter)))

// One lexical pass keeps documentation comments highlighted across lines.
#let program(source, notes, accent) = layout(region => context {
  let size = 8.25pt
  let inset = 7pt
  let gutter = 25pt
  check-width(source, size, region.width - inset * 2 - gutter - 3.5pt)
  block(width: 100%, inset: (x: inset, y: 8pt), radius: 5pt,
    fill: accent.lighten(95%), stroke: 0.5pt + accent.lighten(76%))[
    #set par(leading: 0pt, spacing: 0pt)
    #show raw.where(block: true): it => stack(dir: ttb, spacing: 0pt,
      ..it.lines.map(ln => {
        if ln.text == "" { return block(height: 4.8pt) }
        let mark = notes.position(n => n.at(1) == ln.number)
        let selected = notes.any(n => n.at(1) <= ln.number and ln.number <= n.at(2))
        block(width: 100%, height: 10.25pt,
          grid(columns: (9pt, 11pt, 1fr), column-gutter: 2.5pt, align: horizon,
            if mark != none { marker(letters.at(mark), accent, size: 8.8pt) },
            align(right, text(font: mono, size: 5.6pt, fill: secondary, str(ln.number))),
            block(width: 100%, height: 10.25pt, inset: (left: 3.5pt), stroke: (
              left: if selected { 1.15pt + accent } else { none }), ln.body),
          ))
      }))
    #highlighted(source, size)
  ]
})

#let annotation(lines, note, index, accent) = {
  let (title, start, end, body) = note
  assert(1 <= start and start <= end and end <= lines.len(), message: title + ": invalid excerpt")
  block(width: 100%, breakable: false)[
    #grid(columns: (12pt, 1fr, auto), column-gutter: 4.5pt, align: horizon,
      marker(letters.at(index), accent), subhead(title),
      text(font: mono, size: 6.6pt, fill: secondary, str(start) + "–" + str(end)))
    #v(3.8pt)
    #block(width: 100%, inset: (left: 7pt, right: 4pt, y: 4pt),
      stroke: (left: 1.25pt + accent), fill: accent.lighten(96%))[
      #code(lines.slice(start - 1, end).join("\n"))
    ]
    #v(3.5pt)
    #body
  ]
}

#let column(title, parts, accent, gap: 6pt) = layout(region => context {
  let heading = block(width: 100%)[#label(title, fill: accent)#v(5pt)]
  let natural = measure(stack(dir: ttb, spacing: gap, ..parts), width: region.width).height
  let spare = column-height - measure(heading, width: region.width).height - natural
  assert(spare >= 0pt, message: title + " needs " + repr(-spare) + " more height")
  block(width: 100%, height: column-height)[
    #heading
    #stack(dir: ttb, spacing: gap + spare / (parts.len() - 1), ..parts)
  ]
})

#let dist(name, support, detail) = block(width: 100%, breakable: false)[
  #grid(columns: (1fr, auto), column-gutter: 2pt, align: bottom,
    text(font: mono, size: 7.9pt, weight: "bold", name),
    text(size: 8pt, fill: secondary, support))
  #v(2.2pt)
  #detail
]

#let sheet(number: "", title: "", topic: "", accent: ink, formula: (), file: "",
  example: "", illustration: (), notes: (), variants: (), reference-title: "Reference",
  references: (), after-notes: ()) = {
  let source = read(file).trim()
  let lines = source.split("\n")
  let fig = illustration
  set document(title: if sys.inputs.at("collection", default: "false") == "true" {
    "FlatPPL / Cheatsheets"
  } else { "FlatPPL / " + title }, author: "FlatPPL")
  set page(paper: "a4", flipped: true, margin: (x: 20pt, top: 17pt, bottom: 17pt))
  set text(font: sans, size: 8.65pt, fill: ink, lang: "en")
  set par(leading: 3.4pt, spacing: 4pt, justify: false)
  set block(above: 0pt, below: 0pt)
  show raw.where(block: false): set text(font: mono, size: 7.65pt, fill: ink)
  show heading.where(level: 1): it => text(font: serif, size: 28.5pt, weight: "regular", fill: ink, it.body)
  set math.equation(numbering: none)
  block(width: 100%, height: 51pt)[
    #grid(columns: (35pt, 1fr, 211pt, 44pt), column-gutter: 11pt, align: horizon,
      image("../branding/logo-rounded.svg", width: 35pt, alt: "FlatPPL"),
      [
        #text(font: sans, size: 8.3pt, weight: "bold", fill: ink)[FlatPPL 0.1]
        #h(4pt)#text(fill: secondary)[/]#h(4pt)#label(topic, fill: accent)
        #v(3.7pt)
        #heading(level: 1, title)
      ],
      block(inset: (left: 9pt), stroke: (left: 1pt + accent))[
        #label(formula.at(0), fill: accent)
        #v(4pt)
        #text(size: 12.2pt, formula.at(1))
      ],
      align(right)[#text(font: serif, size: 19pt, fill: accent, number)#h(1.5pt)#text(size: 7.5pt, fill: secondary, "/ 07")],
    )
  ]
  line(length: 100%, stroke: 0.85pt + accent)
  v(8pt)
  grid(columns: (1.14fr, 1fr, 1fr), column-gutter: 14pt,
    column("Complete example", (
      block(width: 100%)[#subhead(example, size: 15pt)#v(5pt)#program(source, notes, accent)],
      ..variants,
    ), accent),
    column("Annotated lines", (
      ..notes.enumerate().map(((i,n)) => annotation(lines, n, i, accent)),
      ..after-notes,
    ), accent),
    column(reference-title, (
      block(width: 100%)[
        #subhead(fig.at(0), size: 15pt)
        #v(4pt)
        #image(file.replace("examples/", "figures/").replace(".flatppl", ".svg"),
          width: 100%, alt: fig.at(1))
        #v(3pt)
        #text(fill: secondary, fig.at(2))
      ],
      ..references,
    ), accent),
  )
}
