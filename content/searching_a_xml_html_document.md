# Searching an HTML / XML Document

## Basic Searching

Let's suppose you have the following document:

~~~ inline assets/shows.xml

Let's further suppose that you want a list of all the characters in
all the shows in this document.

~~~ ruby assets/search-setup.rb
~~~ ruby assets/search-xpath-characters.rb

The `Node` methods `xpath` and `css` actually return a [NodeSet][],
which acts very much like an array, and contains matching nodes from
the document.

  [NodeSet]: http://nokogiri.org/Nokogiri/XML/NodeSet.html

~~~ ruby assets/search-xpath-characters-first.rb

You can use any XPath or CSS query you like (see the chapter on XPath
and CSS syntax for more information).

~~~ ruby assets/search-xpath-characters-drama.rb

Notably, you can even use CSS queries in an XML document!

~~~ ruby assets/search-css-name-sitcoms.rb

CSS queries are often the easiest and most succinct way to express
what you're looking for, so don't be afraid to use them!

## Single Results

If you know you're going to get only a single result back, you can use
the shortcuts `at_css` and `at_xpath` instead of having to access the
first element of a NodeSet.

~~~ ruby assets/search-single-results.rb

## Namespaces

Just like our Ruby code, XML can suffer from name collisions.  For example,
an autoparts dealer can sell tires and so can a bike dealer.  Both of them
may use a "tire" tag to describe the tires they sell.  However, we need to be
able to tell the difference between a *car tire* and a *bike tire*.  This is
where namespaces come to the rescue.

Namespaces associate tags with a unique URL.  Let's take a look at the autoparts
store's XML versus the bike stores:

~~~ inline assets/parts.xml

Since the URLs are unique, we can associate our query with a URL and get only
the tires belonging to *that* url:

~~~ ruby assets/search-xpath-namespace-verbose.rb

To make this namespace registration a bit easier, nokogiri will automatically
register any namespaces it finds on the root node *for you*.  Nokogiri will
associate the name in the declaration with the supplied URL.  If we stick to
this naming convention, we can shorten up our code.

Let's take this atom feed for example:

~~~ inline assets/atom.xml

If we stick to the convention, we can grab all title tags like this

~~~ ruby assets/search-atom-xpath-title.rb

Don't be fooled though.  You *do not* have to use XPath to get the benefits of
namespaces.  CSS selectors can be used as well.  CSS just uses the pipe symbol
to indicate a namespace search.

Let's see the previous search rewritten to use CSS:

~~~ ruby assets/search-atom-css-title.rb

When using CSS, if the namespace is called "xmlns", you can even omit the
namespace name.  That means your CSS will reduce to:

~~~ ruby assets/search-atom-css-short-title.rb

Dealing with namespaces is a broad topic.  If you need more examples, be sure
to check out [this blog post][1] or send an email to the [mailing list][2], and
we can help out.


## But I'm Lazy and Don't Want to Deal With Namespaces!

Lazy == Efficient, so no judgements. :)

If you have an XML document with namespaces, but would prefer to
ignore them entirely (and query as if Tim Bray had never invented
them), then you can call [remove_namespaces][] on an XML::Document to
remove all namespaces. Of course, if the document had nodes with the
same names but different namespaces, they will now be ambiguous. But
you're lazy! You don't care!

  [1]: http://tenderlovemaking.com/2009/04/23/namespaces-in-xml/
  [2]: http://groups.google.com/group/nokogiri-talk
  [remove_namespaces]: http://nokogiri.org/Nokogiri/XML/Document.html#method-i-remove_namespaces-21

## Slop<sup>1</sup>

Maybe you want a more interactive (read: sloppy) way to access nodes
and attributes. If you like what [XmlSimple][3] does, then you'll
probably like Nokogiri's Slop mode.<sup>2</sup>

  [3]: http://xml-simple.rubyforge.org/

Slop mode allows you to violate the Law of Demeter with extreme
prejudice, by using `#method_missing` to introspect on a node's child tags. <sup>3</sup>

~~~ ruby assets/search-slop.rb

Aww yeah. Can you feel the spirit of [@jbarnette][jbarnette] and
[@nakajima][nakajima] flowing through you? That's the power of the
*slop*.<sup>4</sup>

1. Don't use this.
2. This may or may not be a backhanded compliment.
3. No, really, don't use this. If you use it, don't report bugs.
4. You've been warned!

  [jbarnette]: http://twitter.com/jbarnette
  [nakajima]: http://twitter.com/nakajima
