require 'rubygems'
require 'nokogiri'
# :startdoc:
@doc = Nokogiri::HTML::DocumentFragment.parse <<-EOHTML
<body>
  <h1>Three's Company</h1>
  <div>A love triangle.</div>
</body>
EOHTML
