# Modifying an HTML / XML Document

## Changing text contents

Assuming we have the following HTML document:

~~~ ruby assets/modify-setup.rb

Let's change the header's text contents:

~~~ ruby assets/modify-change-content.rb

Pow!

## Moving nodes

The simplest method of moving a node is assign its parent:

~~~ ruby assets/modify-reparent.rb

But you could also arrange it next to other nodes:

~~~ ruby assets/modify-sibling.rb

## Modifying Nodes and Attributes

~~~ ruby assets/modify-nodes-and-attrs.rb

## Creating new nodes

~~~ ruby assets/modify-creating-new-nodes.rb

## Wrapping a NodeSet

If you wanted to wrap new HTML around each node in a Nodeset, here's an example of how to do it:

~~~ ruby assets/modify-wrap.rb
