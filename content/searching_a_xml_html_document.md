# Searching an HTML / XML Document

## Basic Searching

Let's suppose you have the following document:

~~~ inline assets/shows.xml

Let's further suppose that you want a list of all the characters in
all the shows in this document.

~~~ ruby assets/search-setup.rb
~~~ ruby assets/search-xpath-characters.rb

The variable `characters` is actually a [NodeSet][], which acts very much
like an array, and contains matching nodes from the document.

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
