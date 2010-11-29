require 'rubygems'
require 'nokogiri'
# :startdoc:
doc = Nokogiri::XML "<root>foo</root>"
doc.to_xml
# =>

pi = Nokogiri::XML::ProcessingInstruction.new doc, "xml-stylesheet", 'type="text/xsl" href="foo.xsl"'
doc.root.add_previous_sibling pi
doc.to_xml
# =>
