require 'modify-setup'
h1  = @doc.at_css "h1"
div = @doc.at_css "div"
# :startdoc:
nodes = @doc.css "h1,div"
wrapper = nodes.wrap("<div class='container'></div>")

@doc.to_html
# =>
