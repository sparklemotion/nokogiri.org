require 'modify-setup'
h1  = @doc.at_css "h1"
div = @doc.at_css "div"
# :startdoc:
h3 = Nokogiri::XML::Node.new "h3", @doc
h3.content = "1977 - 1984"
h1.add_next_sibling(h3)

@doc.to_html
# =>
