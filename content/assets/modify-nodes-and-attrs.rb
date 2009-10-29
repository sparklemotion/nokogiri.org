require 'modify-setup'
h1 = @doc.at_css "h1"
div = @doc.at_css "div"
# :startdoc:
h1.name = 'h2'
h1['class'] = 'show-title'

@doc.to_html
# =>
