require 'rubygems'
require 'nokogiri'
require 'readable-node'
# :startdoc:
@doc = Nokogiri::XML(File.read("parts.xml"))

car_tires = @doc.xpath('//car:tire', 'car' => 'http://alicesautoparts.com/')
# =>

bike_tires = @doc.xpath('//bike:tire', 'bike' => 'http://bobsbikes.com/')
# =>
