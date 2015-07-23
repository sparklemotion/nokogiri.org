# Modifying an HTML / XML Document

## Changing text contents

Assuming we have the following HTML document:

~~~ ruby assets/modify-setup.rb

Let's change the header's text contents:

~~~ ruby assets/modify-change-content.rb

You'll notice that, when you use `#content=`, entities are properly
escaped. Pow!

## Moving nodes

The simplest method of moving a node is assign its parent:

~~~ ruby assets/modify-reparent.rb

But you could also arrange it next to other nodes:

~~~ ruby assets/modify-sibling.rb

## Modifying Nodes and Attributes

~~~ ruby assets/modify-nodes-and-attrs.rb


## Creating new nodes

Often the easiest thing to do is pass markup to one of the `Node` methods to create siblings:

~~~ ruby assets/modify-creating-new-nodes-with-tags.rb

or you can manually create a node object, if you're a detail-oriented person:

~~~ ruby assets/modify-creating-new-nodes.rb


## Wrapping a NodeSet

If you wanted to wrap new HTML around each node in a Nodeset, here's an example of how to do it:

~~~ ruby assets/modify-wrap.rb

## Adding a Processing Instruction

### (like &lt;?xml-stylesheet?&gt;)

If you want to add a processing instruction (a.k.a. "PI node"), like
an xml-stylesheet declaration, you should first create the node using
`Nokogiri::XML::ProcessingInstruction.new` and then add it to the
document as a previous-sibling of the root node:

~~~ ruby assets/modify-processing-instructions.rb
