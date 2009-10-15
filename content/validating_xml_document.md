# Ruby Cookbook Redux: Validating an XML Document (11.1)

## Problem

_"You want to check that an XML document is well-formed before processing it."_

Notably not covered in this recipe is the topic of validating an XML
document against a DTD. DTD validation will be covered in 11.7,
_Validating an XML Document_.


## Prefatory Note

Nokogiri, by default, does a very good job of fixing up malformed XML
and HTML, thanks to the awesomeness of libxml2. So, if you're only
checking for malformedness so that you know whether to give up on it,
you should try allowing Nokogiri to fix it up first. Check out 11.1
for details!

However, you probably have a very good reason for checking
well-formedness (since you're brilliant), so if you really don't care
about fixing broken markup, then read on.


## Gentle Well-Formedness

If you're using the default parsing options, Nokogiri will attempt to fix
broken markup. But it will return parsing errors to you in the `errors` array.

Thus, you could use `errors.empty?` as a proxy for determining whether
there were any markup problems in the first place.

    badly_formed = <<-EOXML
    <root>
      <open>foo
        <closed>bar</closed>
    </root>  
    EOXML
    
    bad_doc  = Nokogiri::XML badly_formed
    
    puts bad_doc         # => <?xml version="1.0"?>
                         #    <root>
                         #      <open>foo
                         #        <closed>bar</closed>
                         #    </open>  
                         #    </root>
    
    puts bad_doc.errors.empty?  # => false

    puts bad_doc.errors  # => Opening and ending tag mismatch: open line 2 and root
                         #    Premature end of data in tag root line 1

 A valid document's `errors` will return an empty array:

    well_formed = <<-EOXML
    <root>
      <parent>foo
        <child>bar</child>
      </parent>
    </root>  
    EOXML
    
    good_doc = Nokogiri::XML well_formed
    puts good_doc.errors.empty?           # => true


## Strict Well-Formedness

Being friendly and fixing markup is all well and good, but sometimes
you need to be a [Markup
Nazi](http://en.wikipedia.org/wiki/The_Soup_Nazi).

If you demand compliance from your XML, then you can put Nokogiri into
"strict" parsing mode, in which it will raise an exception at the
first sign of malformedness:

    options = Nokogiri::XML::ParseOptions::STRICT
    begin
      bad_doc = Nokogiri::XML badly_formed, nil, nil, options
    rescue Nokogiri::XML::SyntaxError => e
      puts "caught exception: #{e}"
    end
    # => caught exception: Premature end of data in tag root line 1
