require 'search-setup'
# :startdoc:
characters = @doc.css("sitcoms name")
characters.collect { |c| c.to_s }
# =>
