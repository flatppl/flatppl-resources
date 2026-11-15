#let ink = rgb("202a30")
#let muted = rgb("647078")
#let paper = white
#let model-color = rgb("3f5d6c")
#let graph-color = rgb("236d62")
#let reference-color = rgb("9a6936")
#let mono = ("DejaVu Sans Mono", "Menlo")

#let label(body, color: muted) = text(size: 7pt, weight: "bold", tracking: 0.45pt, fill: color, upper(body))

#let code(source, size: 7.0pt) = {
  set text(font: mono, size: size, fill: ink)
  set par(leading: 2.2pt, spacing: 0pt)
  raw(source, block: true, lang: "flatppl",
    syntaxes: "syntax/flatppl.sublime-syntax", theme: "syntax/flatppl.tmTheme")
}

#let card(body, color: graph-color) = block(
  width: 100%, breakable: false, inset: 6pt,
  radius: 5pt, fill: color.lighten(93%), body,
)

#let frame(title, color, body) = block(
  width: 100%, height: 444pt, inset: 7pt,
  radius: 9pt, stroke: 1.7pt + color,
)[
  #text(size: 11.5pt, weight: "bold", fill: color, title)
  #v(6pt)
  #body
]

#let excerpt(lines, start, end, accent) = block(width: 100%, inset: (y: 4pt))[
  #code(lines.slice(start - 1, end).join("\n"), size: 6.6pt)
]

#let note(lines, accent, number, title, start, end, body) = card(color: graph-color)[
  #grid(columns: (12pt, 1fr, 30pt), gutter: 4pt, align: horizon,
    box(width: 12pt, height: 12pt, fill: graph-color, radius: 6pt,
      align(center + horizon, text(fill: white, size: 7pt, weight: "bold", str(number)))),
    text(size: 8.2pt, weight: "bold", fill: graph-color, title),
    text(size: 6pt, fill: graph-color, "L" + str(start) + "-" + str(end)),
  )
  #excerpt(lines, start, end, accent)
  #text(fill: graph-color.darken(25%), body)
]

#let ref(title, body) = card(color: reference-color)[
  #label(color: reference-color, title)
  #v(4pt)
  #body
]

#let dist(name, support, detail) = block(width: 100%, breakable: false)[
  #text(font: mono, size: 6.4pt, weight: "bold", name)
  #h(1fr)#text(size: 6.5pt, fill: muted, support)
  #linebreak()
  #text(size: 7.0pt, detail)
]

#let sheet(number: "01", title: "", subtitle: "", topic: "", accent: model-color,
  file: "", model_title: "", model_note: [], notes: (), refs: (), takeaway: [], sources: "") = {
  let lines = read(file).trim().split("\n")
  set document(title: if sys.inputs.at("collection", default: "false") == "true" {
    "FlatPPL / Cheatsheets"
  } else { "FlatPPL / " + title }, author: "")
  set page(paper: "a4", flipped: true, margin: (x: 8mm, top: 8mm, bottom: 10mm), fill: paper,
    footer: grid(columns: (1fr, auto), gutter: 10pt,
      text(size: 5.8pt, fill: muted, sources),
      text(size: 5.8pt, fill: muted)[FlatPPL 0.1 · #number / 04],
    ),
  )
  set text(font: ("Helvetica Neue", "Arial"), size: 7.7pt, fill: ink)
  set par(leading: 2.8pt, spacing: 4pt)
  show raw.where(block: false): it => text(font: mono, size: 0.9em, fill: ink, it)

  grid(columns: (34pt, auto, 1fr, auto), gutter: 9pt, align: horizon,
    image("../branding/logo-rounded.svg", width: 34pt, height: 34pt),
    text(size: 21pt, weight: "bold")[FlatPPL],
    [
      #text(size: 14pt, weight: "bold", fill: accent, title)
      #linebreak()
      #label(color: muted)[#topic]
    ],
    label(color: accent)[#number / 04],
  )
  v(5pt)
  text(size: 8.0pt, fill: muted, subtitle)
  v(8pt)

  grid(columns: (1.1fr, 1fr, 1fr), column-gutter: 10pt,
    frame("Example", model-color)[
      #card(color: model-color)[
        #label(color: model-color, model_title)
        #v(5pt)
        #set par(leading: 0pt, spacing: 0pt)
        #show raw.line: ln => {
          let active = notes.filter(n => ln.number >= n.at(2) and ln.number <= n.at(3))
          let starts = notes.filter(n => ln.number == n.at(2))
          block(width: 100%, fill: if active.len() > 0 { model-color.lighten(86%) } else { none },
            grid(columns: (9pt, 11pt, 1fr), gutter: 3pt, align: horizon,
              if starts.len() > 0 {
                box(width: 9pt, height: 9pt, fill: graph-color, radius: 4.5pt,
                  align(center + horizon, text(size: 5.5pt, weight: "bold", fill: white, str(starts.first().at(0)))))
              } else { [] },
              align(right, text(font: mono, size: 5.5pt, fill: muted, str(ln.number))),
              if ln.text == "" { [#h(1pt)] } else { ln.body },
            ),
          )
          v(1.5pt)
        }
        #code(lines.join("\n"), size: 6.6pt)
      ]
      #v(7pt)
      #card(color: model-color)[#text(fill: model-color.darken(20%), model_note)]
    ],
    frame("Language constructs", graph-color)[
      #for n in notes {
        note(lines, accent, ..n)
        v(6pt)
      }
    ],
    frame("Reference", reference-color)[
      #for r in refs {
        r
        v(6pt)
      }
    ],
  )
  v(7pt)
  block(width: 100%, inset: (x: 7pt, y: 5pt), fill: accent.lighten(93%), radius: 5pt)[
    #text(size: 7.3pt, fill: accent.darken(20%), takeaway)
  ]
}
