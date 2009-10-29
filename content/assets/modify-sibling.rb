require 'modify-setup'
h1 = @doc.at_css "h1"
div = @doc.at_css "div"
# :startdoc:
div.add_next_sibling(h1)

@doc.to_html
# =>
