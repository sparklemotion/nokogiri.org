require 'search-setup'
# :startdoc:
characters = @doc.xpath("//character")
characters.collect { |c| c.to_s }
# =>
