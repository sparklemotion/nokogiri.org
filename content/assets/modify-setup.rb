require 'rubygems'
require 'nokogiri'
# :startdoc:
@doc = Nokogiri::HTML <<-EOHTML
<html>
  <body>
    <h1>Three's Company</h1>
    <div>A love triangle.</div>
  </body>
</html>
EOHTML
