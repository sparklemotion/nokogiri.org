require 'modify-setup'
h1  = @doc.at_css "h1"
div = @doc.at_css "div"
# :startdoc:
h1.add_next_sibling "<h3>1977 - 1984</h3>"

@doc.to_html
# =>
