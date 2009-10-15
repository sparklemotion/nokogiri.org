Ruby Cookbook Redux: Chapter 11
=====

Win
-----

I've never won anything. Once, at a golf tournament, I won a Yankees hat. But [I'm a Red Sox fan](http://flavoriffic.blogspot.com/2004/10/true-story-this-morning-standing-in.html), so I gave it away for a 3-pack of Titleists and a brownie.

But at [GoRuCo](http://www.goruco.com/) 2009, my ship came in: I won a copy of [_Ruby Cookbook_](http://oreilly.com/catalog/9780596523695/) by Lucas Carlson and Leonard Richardson. Nice!

When I recovered from the [after-party](http://img39.imageshack.us/my.php?image=xek.jpg&via=tfrog), I cracked it open and scanned the TOC. Chapter 11! _"XML and HTML"!_ Why, that's what I do all day long! What pearls of wisdom lay in store for me between pages 371 and 408?

Lose
-----

As it turns out, Chapter 11 is kind of a dud. Published in 2006, this section in particular is really showing its age. [Nokogiri](http://nokogiri.rubyforge.org/nokogiri/) hadn't been born yet, and [Hpricot](http://code.whytheluckystiff.net/doc/hpricot/) was just a [glint in \_why's eye](http://redhanded.hobix.com/inspect/hpricot01.html). Most of the examples are solved using [REXML](http://www.germane-software.com/software/rexml/), although [libxml-ruby](http://libxml.rubyforge.org/) makes a brief cameo as well.

Technology moves fast! We can do better than REXML these days. My personal favorite XML/HTML library is Nokogiri, which (I'm sure I don't have to tell you, as you are a handsome/beautiful genius) [performs well in benchmarks](http://github.com/tenderlove/xml_truth), supports XPath and CSS queries and has lots of other nice features.

Then it hit me: _Chapter 11 should be rewritten using Nokogiri!_ I'll generate some useful documentation, global warming will be stopped in its tracks, and the world will sing in perfect harmony about Coca-Cola and Nokogiri. __Win!__


Write
-----

So, welcome to my latest project. I'll be blogging a short post for each of the sections in Chapter 11 demonstrating Nokogiri's sweet awesomeness. I'll tackle them in a different order than the original book, but in what I think is a more logical series. Each section will build on previous sections. It'll be fun! I promise.
