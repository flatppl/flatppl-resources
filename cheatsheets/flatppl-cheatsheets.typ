#import "theme.typ": sheet-names

#for (index, name) in sheet-names.enumerate() {
  if index > 0 { pagebreak() }
  include (name + ".typ")
}
