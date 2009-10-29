require 'rubygems'
require 'nokogiri'
# :startdoc:
@doc = Nokogiri::XML(File.open("shows.xml"))
