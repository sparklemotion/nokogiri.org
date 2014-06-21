require 'modify-setup'
# :startdoc:
nodes = @doc.css "h1,div"
nodes.wrap("<div class='container'></div>")

@doc.to_html
# =>
