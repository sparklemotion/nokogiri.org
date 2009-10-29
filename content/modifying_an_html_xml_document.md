# Modifying an HTML / XML Document

## Changing text contents

Assuming we have the following HTML document:

    doc = Nokogiri::HTML <<-EOHTML
      <html>
        <body>
          <h1>Three's Company</h1>
          <div>A love triangle.</div>
        </body>
      </html>
    EOHTML

Let's change the header's text contents:

    h1 = doc.at_css "h1"
    h1.content = "Snap, Crackle and Pop"

    puts doc.to_html
    # => <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
         <html><body>
           <h1>Snap, Crackle and Pop</h1>
           <div>A love triangle.</div>
         </body></html>

Pow!

## Moving nodes

The simplest method of moving a node is assign its parent:

    h1 = doc.at_css "h1"
    div = doc.at_css "div"
    h1.parent = div

    puts doc.to_html
    # => <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
         <html><body>
          <div>A love triangle.<h1>Three's Company</h1></div>
         </body></html>

But you could also arrange it next to other nodes:

    div.add_next_sibling(h1)

    puts doc.to_html
    # => <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
         <html><body>
           <div>A love triangle.</div><h1>Three's Company</h1>
         </body></html>

## Modifying Nodes and Attributes

    h1.name = 'h2'
    h1['class'] = 'show-title'

    puts doc.to_html
    # => <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
         <html><body>
           <h2 class="show-title">Three's Company</h2>
           <div>A love triangle.</div>
         </body></html>

## Creating new nodes

    h3 = Nokogiri::XML::Node.new "h3", doc
    h3.content = "1977 - 1984"

    puts doc.to_s
    # => <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
         <html><body>
           <h1>Three's Company</h1><h3>1977 - 1984</h3>
           <div>A love triangle.</div>
         </body></html>

## Wrapping a NodeSet

If you wanted to wrap new HTML around each node in a Nodeset, here's an example of how to do it:

    body = doc.at_css "body"
    nodes = doc.css "h1,div"

    wrapper = nodes.wrap("<div class='container'></div>")

    puts doc.to_html
    # => <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" "http://www.w3.org/TR/REC-html40/loose.dtd">
         <html><body>
           <div class="container"><h1>Three's Company</h1></div>
           <div class="container"><div>A love triangle.</div></div>
         </body></html>
