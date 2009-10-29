require 'search-setup'
# :startdoc:
characters = @doc.xpath("//dramas//character")
characters.collect { |c| c.to_s }
# =>
