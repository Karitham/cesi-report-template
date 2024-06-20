#let IMAGE_BOX_MAX_WIDTH = 120pt
#let IMAGE_BOX_MAX_HEIGHT = 50pt

#let project(
  title: "",
  subtitle: none,
  school-logo: none,
  company-logo: none,
  authors: ((link: none, name: none),),
  mentors: ((link: none, name: none),),
  jury: ((link: none, name: none),),
  branch: none,
  academic-year: none,
  french: false,
  table-of-tables: false,
  table-of-figures: false,
  table-of-contents: true,
  blank-page: true,
  footer-text: "CESI",
  body,
) = {
  // Set the document's basic properties.
  set document(author: authors.map(it => it.name), title: title)
  set page(
    numbering: "1",
    number-align: center,
    footer: locate(loc => {
      // Omit page number on the first page
      let page-number = counter(page).at(loc).at(0)
      // No footer on first and second page.
      let no-footer = 1
      if blank-page {
        no-footer += 1
      }
      if page-number > no-footer {
        line(length: 100%, stroke: 0.5pt)
        v(-2pt)
        text(
          size: 12pt,
          weight: "regular",
        )[
          #grid(
            columns: (1fr, 1fr, 1fr),
            align: center,
            [#footer-text], [#page-number], [#academic-year],
          )
        ]
      }
    }),
  )

  let dict = json("resources/i18n/en.json")
  let lang = "en"
  if french {
    dict = json("resources/i18n/fr.json")
    lang = "fr"
  }

  set text(
    font: ("DejaVu Serif", "arial", "Linux Libertine"),
    lang: lang,
    size: 12pt,
  )
  set heading(numbering: "1.1")

  let format_link = body => underline(
    offset: 2pt,
    stroke: 1.5pt + rgb("#fbe216"),
    body,
  )

  show link: it => format_link(it)
  show ref: it => format_link(it)

  show heading: it => {
    if it.level == 1 and it.numbering != none {
      pagebreak()
      v(40pt)
      text(size: 30pt)[#dict.chapter #counter(heading).display() #linebreak() #it.body ]
      v(60pt)
    } else {
      v(5pt)
      [#it]
      v(12pt)
    }
  }

  block[
    #box(height: IMAGE_BOX_MAX_HEIGHT, width: IMAGE_BOX_MAX_WIDTH)[
      #align(left + horizon)[
        #company-logo
      ]
    ]
    #h(1fr)
    #box(height: IMAGE_BOX_MAX_HEIGHT, width: IMAGE_BOX_MAX_WIDTH)[
      #align(right + horizon)[
        #if school-logo == none {
          image("images/CESI.svg")
        } else {
          school-logo
        }
      ]
    ]
  ]

  // Title box
  align(center + horizon)[
    #if subtitle != none {
      text(size: 14pt, tracking: 2pt)[
        #smallcaps[
          #subtitle
        ]
      ]
    }
    #line(length: 100%, stroke: 0.5pt)
    #text(size: 20pt, weight: "bold")[#title]
    #line(length: 100%, stroke: 0.5pt)
  ]

  // Credits
  box()
  h(1fr)
  grid(
    columns: (auto, 1fr, auto),
    [
      // Authors
      #if authors.len() > 0 {
        [
          #text(weight: "bold")[
            #if authors.len() > 1 {
              dict.author_plural
            } else {
              dict.author
            }
            #linebreak()
          ]
          #for author in authors {
            if author.link != none {
              link(author.link, author.name)
            } else {
              author.name
            }
            linebreak()
          }
        ]
      }
    ], [
      // Mentor
      #if mentors != none and mentors.len() > 0 {
        align(right)[
          #text(weight: "bold")[
            #if mentors.len() > 1 {
              dict.mentor_plural
            } else {
              dict.mentor
            }
            #linebreak()
          ]
          #for mentor in mentors {
            if mentor.link != none {
              link(mentor.link, mentor.name)
            } else {
              mentor.name
            }

            linebreak()
          }
        ]
      }
      // Jury
      #if jury != none and jury.len() > 0 {
        align(right)[
          *#dict.jury* #linebreak()
          #for prof in jury {
            if prof.link != none {
              link(prof.link, prof.name)
            } else {
              prof.name
            }

            linebreak()
          }
        ]
      }
    ],

  )

  align(center + bottom)[
    #if branch != none {
      branch
      linebreak()
    }
    #if academic-year != none {
      [#dict.academic_year: #academic-year]
    }
  ]

  if blank-page {
    pagebreak()
  }

  if table-of-contents {
    pagebreak()
    outline(depth: 3, indent: true)
  }

  if table-of-figures {
    pagebreak()
    outline(title: dict.figures_table, target: figure.where(kind: image))
  }

  if table-of-tables {
    pagebreak()
    outline(title: dict.tables_table, target: figure.where(kind: table))
  }

  body
}