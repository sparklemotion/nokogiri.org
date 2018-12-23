require 'rubygems'
require 'nokogiri'
require 'readable-node'
# :startdoc:
@doc = Nokogiri::XML(File.open("shows.xml"))
