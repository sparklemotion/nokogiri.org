# Searching an HTML / XML Document

## Basic Searching

Let's suppose you have the following document:

```xml
[shows.xml]
<root>
  <sitcoms>
    <sitcom>
      <name>Married with Children</name>
      <characters>
        <character>Al Bundy</character>
        <character>Bud Bundy</character>
        <character>Marcy Darcy</character>
      </characters>
    </sitcom>
    <sitcom>
      <name>Perfect Strangers</name>
      <characters>
        <character>Larry Appleton</character>
        <character>Balki Bartokomous</character>
      </characters>
    </sitcom>
  </sitcoms>
  <dramas>
    <drama>
      <name>The A-Team</name>
      <characters>
        <character>John "Hannibal" Smith</character>
        <character>Templeton "Face" Peck</character>
        <character>"B.A." Baracus</character>
        <character>"Howling Mad" Murdock</character>
      </characters>
    </drama>
  </dramas>
</root>

```

Let's further suppose that you want a list of all the characters in
all the shows in this document.

```ruby

@doc = Nokogiri::XML(File.open("shows.xml"))
```
```ruby

@doc.xpath("//character")
# => ["<character>Al Bundy</character>",
#    "<character>Bud Bundy</character>",
#    "<character>Marcy Darcy</character>",
#    "<character>Larry Appleton</character>",
#    "<character>Balki Bartokomous</character>",
#    "<character>John \"Hannibal\" Smith</character>",
#    "<character>Templeton \"Face\" Peck</character>",
#    "<character>\"B.A.\" Baracus</character>",
#    "<character>\"Howling Mad\" Murdock</character>"]
```

The `Node` methods `xpath` and `css` actually return a [NodeSet][],
which acts very much like an array, and contains matching nodes from
the document.

  [NodeSet]: http://nokogiri.org/Nokogiri/XML/NodeSet.html

```ruby

characters[0].to_s # => "<character>Al Bundy</character>"
```

You can use any XPath or CSS query you like (see the chapter on XPath
and CSS syntax for more information).

```ruby

@doc.xpath("//dramas//character")
# => ["<character>John \"Hannibal\" Smith</character>",
#    "<character>Templeton \"Face\" Peck</character>",
#    "<character>\"B.A.\" Baracus</character>",
#    "<character>\"Howling Mad\" Murdock</character>"]
```

Notably, you can even use CSS queries in an XML document!

```ruby

characters = @doc.css("sitcoms name") # => ["<name>Married with Children</name>", "<name>Perfect Strangers</name>"] # !> assigned but unused variable - characters
```

CSS queries are often the easiest and most succinct way to express
what you're looking for, so don't be afraid to use them!

## Single Results

If you know you're going to get only a single result back, you can use
the shortcuts `at_css` and `at_xpath` instead of having to access the
first element of a NodeSet.

```ruby

@doc.css("dramas name").first # => "<name>The A-Team</name>"
@doc.at_css("dramas name")    # => "<name>The A-Team</name>"
```

## Namespaces

Just like our Ruby code, XML can suffer from name collisions.  For example,
an autoparts dealer can sell tires and so can a bike dealer.  Both of them
may use a "tire" tag to describe the tires they sell.  However, we need to be
able to tell the difference between a *car tire* and a *bike tire*.  This is
where namespaces come to the rescue.

Namespaces associate tags with a unique URL.  Let's take a look at the autoparts
store's XML versus the bike stores:

```xml
[parts.xml]
<parts>
  <!-- Alice's Auto Parts Store -->
  <inventory xmlns="http://alicesautoparts.com/">
    <tire>all weather</tire>
    <tire>studded</tire>
    <tire>extra wide</tire>
  </inventory>

  <!-- Bob's Bike Shop -->
  <inventory xmlns="http://bobsbikes.com/">
    <tire>street</tire>
    <tire>mountain</tire>
  </inventory>
</parts>

```

Since the URLs are unique, we can associate our query with a URL and get only
the tires belonging to *that* url:

```ruby

@doc = Nokogiri::XML(File.read("parts.xml"))

car_tires = @doc.xpath('//car:tire', 'car' => 'http://alicesautoparts.com/') # !> assigned but unused variable - car_tires
# => ["<tire>all weather</tire>", # !> assigned but unused variable - bike_tires
#    "<tire>studded</tire>",
#    "<tire>extra wide</tire>"]

bike_tires = @doc.xpath('//bike:tire', 'bike' => 'http://bobsbikes.com/')
# => ["<tire>street</tire>", "<tire>mountain</tire>"]
```

To make this namespace registration a bit easier, nokogiri will automatically
register any namespaces it finds on the root node *for you*.  Nokogiri will
associate the name in the declaration with the supplied URL.  If we stick to
this naming convention, we can shorten up our code.

Let's take this atom feed for example:

```xml
[atom.xml]
<?xml version="1.0" encoding="utf-8"?>
<feed xmlns="http://www.w3.org/2005/Atom">

  <title>Example Feed</title>
  <link href="http://example.org/"/>
  <updated>2003-12-13T18:30:02Z</updated>
  <author>
    <name>John Doe</name>
  </author>
  <id>urn:uuid:60a76c80-d399-11d9-b93C-0003939e0af6</id>

  <entry>
    <title>Atom-Powered Robots Run Amok</title>
    <link href="http://example.org/2003/12/13/atom03"/>
    <id>urn:uuid:1225c695-cfb8-4ebb-aaaa-80da344efa6a</id>
    <updated>2003-12-13T18:30:02Z</updated>
    <summary>Some text.</summary>
  </entry>

</feed>

```

If we stick to the convention, we can grab all title tags like this

```ruby

@doc.xpath('//xmlns:title') # => ["<title>Example Feed</title>", "<title>Atom-Powered Robots Run Amok</title>"]
```

Don't be fooled though.  You *do not* have to use XPath to get the benefits of
namespaces.  CSS selectors can be used as well.  CSS just uses the pipe symbol
to indicate a namespace search.

Let's see the previous search rewritten to use CSS:

```ruby

@doc.css('xmlns|title') # => ["<title>Example Feed</title>", "<title>Atom-Powered Robots Run Amok</title>"]

```

When using CSS, if the namespace is called "xmlns", you can even omit the
namespace name.  That means your CSS will reduce to:

```ruby

@doc.css('title') # => ["<title>Example Feed</title>", "<title>Atom-Powered Robots Run Amok</title>"]
```

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

```ruby

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
doc.employees.employee.last.fullname.content # => "Jerry Lewis"

# access node attributes!
doc.employees.employee.first["status"] # => "active"

# use some xpath!
doc.employees.employee("[@status='active']").fullname.content # => "Dean Martin"
doc.employees.employee(:xpath => "@status='active'").fullname.content # => "Dean Martin"

# use some css!
doc.employees.employee("[status='active']").fullname.content # => "Dean Martin"
doc.employees.employee(:css => "[status='active']").fullname.content # => "Dean Martin"
```

Aww yeah. Can you feel the spirit of [@jbarnette][jbarnette] and
[@nakajima][nakajima] flowing through you? That's the power of the
*slop*.<sup>4</sup>

1. Don't use this.
2. This may or may not be a backhanded compliment.
3. No, really, don't use this. If you use it, don't report bugs.
4. You've been warned!

  [jbarnette]: http://twitter.com/jbarnette
  [nakajima]: http://twitter.com/nakajima
