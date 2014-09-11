---
title: Modifying an HTML/XML document
layout: page
sidebar: false
---
# Modifying an HTML / XML Document

## Changing text contents

Assuming we have the following HTML document:

```ruby

@doc = Nokogiri::HTML::DocumentFragment.parse <<-EOHTML
<body>
  <h1>Three's Company</h1>
  <div>A love triangle.</div>
</body>
EOHTML
```

Let's change the header's text contents:

```ruby

h1 = @doc.at_css "h1"
h1.content = "Snap, Crackle and Pop"

@doc.to_html
# => "<body>
#   <h1>Snap, Crackle and Pop</h1>
#   <div>A love triangle.</div>
# 
# </body>"
```

Pow!

## Moving nodes

The simplest method of moving a node is assign its parent:

```ruby

h1  = @doc.at_css "h1"
div = @doc.at_css "div"
h1.parent = div

@doc.to_html
# => "<body>
#   
#   <div>A love triangle.<h1>Three's Company</h1>
# </div>
# 
# </body>"
```

But you could also arrange it next to other nodes:

```ruby

div.add_next_sibling(h1)

@doc.to_html
# => "<body>
#   
#   <div>A love triangle.</div>
# <h1>Three's Company</h1>
# 
# </body>"
```

## Modifying Nodes and Attributes

```ruby

h1.name = 'h2'
h1['class'] = 'show-title'

@doc.to_html
# => "<body>
#   <h2 class=\"show-title\">Three's Company</h2>
#   <div>A love triangle.</div>
# 
# </body>"
```

## Creating new nodes

```ruby

h3 = Nokogiri::XML::Node.new "h3", @doc
h3.content = "1977 - 1984"
h1.add_next_sibling(h3)

@doc.to_html
# => "<body>
#   <h1>Three's Company</h1>
# <h3>1977 - 1984</h3>
#   <div>A love triangle.</div>
# 
# </body>"
```

## Wrapping a NodeSet

If you wanted to wrap new HTML around each node in a Nodeset, here's an example of how to do it:

```ruby

nodes = @doc.css "h1,div"
nodes.wrap("<div class='container'></div>")

@doc.to_html
# => "<body>
#   <div class=\"container\"><h1>Three's Company</h1></div>
#   <div class=\"container\"><div>A love triangle.</div></div>
# 
# </body>"
```

## Adding a Processing Instruction

### (like &lt;?xml-stylesheet?&gt;)

If you want to add a processing instruction (a.k.a. "PI node"), like
an xml-stylesheet declaration, you should first create the node using
`Nokogiri::XML::ProcessingInstruction.new` and then add it to the
document as a previous-sibling of the root node:

```ruby

doc = Nokogiri::XML "<root>foo</root>"
doc.to_xml
# => "<?xml version=\"1.0\"?>
# <root>foo</root>
# "

pi = Nokogiri::XML::ProcessingInstruction.new(doc, "xml-stylesheet",
                                              'type="text/xsl" href="foo.xsl"')
doc.root.add_previous_sibling pi
doc.to_xml
# => "<?xml version=\"1.0\"?>
# <?xml-stylesheet type=\"text/xsl\" href=\"foo.xsl\"?>
# <root>foo</root>
# "
```
