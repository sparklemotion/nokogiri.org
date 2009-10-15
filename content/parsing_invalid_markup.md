# Ruby Cookbook Redux: Parsing Invalid Markup (11.7)

## The Problem 

_"You need to extract data from a document that's supposed to be HTML or XML, but that contains some invalid markup."_


## Fixing Busted Markup Like a Boss

Nokogiri's chewy libxml2 center means that it can correct your
badly-formed documents and tell you exactly what was wrong with the
document. In fact, the default behavior is to do exactly that:

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
    
    puts bad_doc.errors  # => Opening and ending tag mismatch: open line 2 and root
                         #    Premature end of data in tag root line 1


HTML: Not Just For Breakfast Anymore
-----

Nokogiri fixes busted HTML even better than it fixes busted XML. In
fact, libxml2 does an able job of emulating the types of corrections
typically done by web browsers.

# TODO example
