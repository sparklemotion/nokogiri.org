require 'rubygems'
require "nokogiri"
# :startdoc:
doc = Nokogiri::Slop <<-EOXML
<employees>
  <employee status="active">
    <fullname>Dean Martin</fullname>
  </employee>
  <employee status="inactive">
    <fullname>Jerry Lewis</fullname>
  </employee>
</employees>
EOXML

# navigate!
doc.employees.employee.last.fullname.content # => 

# access node attributes!
doc.employees.employee.first["status"] # =>

# use some xpath!
doc.employees.employee("[@status='active']").fullname.content # =>
doc.employees.employee(:xpath => "@status='active'").fullname.content # =>

# use some css!
doc.employees.employee("[status='active']").fullname.content # =>
doc.employees.employee(:css => "[status='active']").fullname.content # =>
