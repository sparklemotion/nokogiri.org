require 'nokogiri/xml/node'
class Nokogiri::XML::Node
  def inspect
    "\"#{to_s.gsub(/\"/,'\"')}\""
  end
end
class Nokogiri::XML::NodeSet
  remove_method :inspect
  def inspect
    strings = collect { |c| c.inspect }
    if length > 2
      "[#{strings.join(",\n")}]"
    else
      "[#{strings.join(", ")}]"
    end
  end
end
