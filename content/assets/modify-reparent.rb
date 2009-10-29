require 'modify-setup'
# :startdoc:
h1 = @doc.at_css "h1"
div = @doc.at_css "div"
h1.parent = div

@doc.to_html
# =>
