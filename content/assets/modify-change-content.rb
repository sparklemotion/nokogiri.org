require 'modify-setup'
# :startdoc:
h1 = @doc.at_css "h1"
h1.content = "Snap, Crackle and Pop"

@doc.to_html
# =>
