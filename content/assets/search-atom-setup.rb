require 'rubygems'
require 'nokogiri'
require 'readable-node'
@doc = Nokogiri::XML File.read("atom.xml")
