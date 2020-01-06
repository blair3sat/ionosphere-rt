using Weave
#HTML
# weave(joinpath(pwd(), "about.jmd"),
#   out_path=:pwd,
#   doctype = "md2html")

convert_doc(joinpath(pwd(), "about.jmd"), joinpath(pwd(), "about.ipynb"), format="notebook")