# Installing Nokogiri

Because Nokogiri needs to be [compiled][] and [dynamically linked][]
against both [libxml2][] and [libxslt][], it has gained a
reputation for being complicated to install.

  [compiled]: http://en.wikipedia.org/wiki/Compiler
  [dynamically linked]: http://en.wikipedia.org/wiki/Dynamic_linker
  [libxml2]: http://xmlsoft.org/index.html
  [libxslt]: http://xmlsoft.org/xslt/

Let's wrassle this little myth to the ground, shall we?

## Ubuntu / Debian

Ubuntu doesn't come with the Ruby development packages that are
required for building gems with C extensions. Here are the commands to
install everything you might need:

```sh
# ruby developer packages
sudo apt-get install ruby1.8-dev ruby1.8 ri1.8 rdoc1.8 irb1.8
sudo apt-get install libreadline-ruby1.8 libruby1.8 libopenssl-ruby

# nokogiri requirements
sudo apt-get install libxslt-dev libxml2-dev
sudo gem install nokogiri
```

Although, if you're using Hardy (8.04) or earlier, you'll need to install slightly different packages:

```sh
# nokogiri requirements for Hardy (8.04) and earlier
sudo apt-get install libxslt1-dev libxml2-dev
```

As [John Barnette once said][package-management], "Isn't package management convenient? :)"

  [package-management]: http://rubyforge.org/pipermail/nokogiri-talk/2009-March/000181.html


## Mac OS X

Most developers are using homebrew to manage their packages these
days. If you are, you're in luck:

### homebrew 0.9.5+

Things pretty much Just Work™ these days. To use nokogiri with its
vendored libxml2 and libxslt you only need to install libiconv:

```sh
gem install nokogiri
```

### Troubleshooting

If you have problems mentioning libiconv missing that looks something like this:

    Installing nokogiri (1.6.2.1) Building nokogiri using packaged libraries.

    Gem::Installer::ExtensionBuildError: ERROR: Failed to build gem native extension.

        /usr/local/rvm/rubies/ruby-2.0.0-p0/bin/ruby extconf.rb
    Building nokogiri using packaged libraries.
    checking for iconv.h... yes
    checking for iconv_open() in iconv.h... no
    checking for iconv_open() in -liconv... no
    checking for libiconv_open() in iconv.h... no
    checking for libiconv_open() in -liconv... no
    -----
    libiconv is missing.  please visit http://nokogiri.org/tutorials/installing_nokogiri.html for help with installing dependencies.
    -----
    *** extconf.rb failed ***

Then you are probably missing the right developer tools. This is a really easy fix:

```sh
brew unlink gcc-4.2      # you might not need this step
gem uninstall nokogiri
xcode-select --install
gem install nokogiri
```

This is verified working on OSX 10.9 w/ xcode's clang compiler.

Many thanks to @allaire and others for helping verify this.

### Other tips:

* Make sure ruby is compiled with the latest clang compiler.
* Ruby is no longer dependent upon gcc-4.2.
* Binary gems and ruby really should be compiled with the same compiler/environment.
* If you have multiple versions of xcode installed, make sure you use the right xcode-select.

If you have any other issues, please file an issue (preferably a new
one) and pull in @zenspider.

## Red Hat / CentOS

The easiest way to get Nokogiri installed on CentOS and RHEL seems to be the
[EPEL][] repository which contains a prebuilt nokogiri package. To use it,
install the appropriate [epel-release][] package for your OS, then run:

```sh
sudo yum install -y rubygem-nokogiri
```

  [EPEL]: http://fedoraproject.org/wiki/EPEL
  [epel-release]: http://fedoraproject.org/wiki/EPEL#How_can_I_use_these_extra_packages.3F

To install using gem install is somewhat more complicated because of the age of
the packages available from the central repositories. If you have rubygems
installed, you may be able to install nokogiri via `gem install`. If you run
intro problems, try installing these packages as well.

```sh
sudo yum install -y gcc ruby-devel libxml2 libxml2-devel libxslt libxslt-devel
```

CentOS 5 (and RHEL5) come installed with libxml 2.6.26 which, while not as
offensively out-of-date as Mac Leopard, is still pretty damn old ([released
June 2006][]) and has [known][] [issues][].

If you're affected by any known bugs or are seeing odd behavior, you
may want to consider uninstalling the RPMs for libxml2 and libxslt,
and building them from source.

  [released June 2006]: http://mail.gnome.org/archives/xml/2006-June/msg00043.html
  [known]: http://github.com/sparklemotion/nokogiri/issues#issue/243
  [issues]: http://github.com/sparklemotion/nokogiri/issues#issue/122

 1. `sudo yum remove -y libxml2-devel libxslt-devel`
 2. download the most recent libxml2 and libxslt from [ftp://xmlsoft.org/libxml2/](ftp://xmlsoft.org/libxml2/)
 3. `./configure ; make ; sudo make install`

Then install nokogiri specifying the libxml2 and libxslt install directories:

```sh
sudo gem install nokogiri -- --with-xml2-lib=/usr/local/lib \
                             --with-xml2-include=/usr/local/include/libxml2 \
                             --with-xslt-lib=/usr/local/lib \
                             --with-xslt-include=/usr/local/include
```

(Note that, by default, libxslt header files are installed into the
root include directory, but libxml2 header files are installed into a
subdirectory thereof named `libxml2`.)

Or, you know, whatever directories into which you installed libxml and
libxslt. Good luck.

## Nonstandard libxml2 / libxslt installations

If you've got libxml2 and/or libxslt installed in a nonstandard place
(read as "not /opt/local, /usr/local, /usr or the standard Ruby
directories"), you can use command-line parameters to the `gem
install` command to grease the wheels:

```sh
gem install nokogiri -- --with-xml2-dir=/home/joe/builds \
                        --with-xslt-dir=/home/joe/builds
```

Or, you can specify include and library directories separately:

```sh
gem install nokogiri -- --with-xml2-lib=/home/joe/builds/lib \
                        --with-xml2-include=/home/joe/builds/include/libxml2 \
                        --with-xslt-lib=/home/joe/builds/lib \
                        --with-xslt-include=/home/joe/builds/include
```

Note that, by default, libxslt header files are installed into the
root include directory, but libxml2 header files are installed into a
subdirectory thereof named `libxml2`.

## Windows

Luckily for you, building on Windows is so difficult that we've done
it for you: Nokogiri comes bundled with all the DLLs you need to be
NOKOGIRIFIED!

```sh
gem install nokogiri
```

# Parsing an HTML / XML Document

## From a String

We've tried to make this easy on you. Really! We're here to make your life easier.

```ruby
html_doc = Nokogiri::HTML("<html><body><h1>Mr. Belvedere Fan Club</h1></body></html>")
xml_doc  = Nokogiri::XML("<root><aliens><alien><name>Alf</name></alien></aliens></root>")
```

The variables `html_doc` and `xml_doc` are Nokogiri documents, which
have all kinds of interesting properties and methods that you [can
read about here][read-document]. We'll cover the interesting bits in other
chapters.

  [read-document]: http://nokogiri.org/Nokogiri/XML/Document.html

## From a File

Note that you don't need to read the file into a string variable. Nokogiri will do this for you.

```ruby
f = File.open("blossom.xml")
doc = Nokogiri::XML(f)
f.close
```

Clever Nokogiri! With the time you just saved, approach enlightenment by meditating on [this koan][].

  [this koan]: http://twitter.com/rjw1/status/2741916767

## From the Internets

I understand that there may be some HTML documents available on the
World Wide Web.

```ruby
require 'open-uri'
doc = Nokogiri::HTML(open("http://www.threescompany.com/"))
```

## Parse Options

Nokogiri offers quite a few options that affect how a document is
parsed. You can [read about them here][read-parse-options], but the
most commonly-used options are:

  [read-parse-options]: http://nokogiri.org/Nokogiri/XML/ParseOptions.html

* `NOBLANKS` - Remove blank nodes
* `NOENT` - Substitute entities
* `NOERROR` - Suppress error reports
* `STRICT` - Strict parsing; raise an error when parsing malformed documents
* `NONET` - Prevent any network connections during parsing. Recommended for parsing untrusted documents.

Here's how they are used:

```ruby
doc = Nokogiri::XML(File.open("blossom.xml")) do |config|
  config.strict.nonet
end
```

Or

```ruby
doc = Nokogiri::XML(File.open("blossom.xml")) do |config|
  config.options = Nokogiri::XML::ParseOptions.STRICT | Nokogiri::XML::ParseOptions.NONET
end
```

## Encoding

Strings are always stored as UTF-8 internally.  Methods that return
text values will always return UTF-8 encoded strings.  Methods that
return XML (like to_xml, to_html and inner_html) will return a string
encoded like the source document.

**WARNING**

Some documents declare one particular encoding, but use a different
one. So, which encoding should the parser choose?

Remember that data is just a stream of bytes. Only us humans add
meaning to that stream. Any particular set of bytes could be valid
characters in multiple encodings, so detecting encoding with 100%
accuracy is not possible. libxml2 does its best, but it can't be right
100% of the time.

If you want Nokogiri to handle the document encoding properly, your
best bet is to explicitly set the encoding.  Here is an example of
explicitly setting the encoding to EUC-JP on the parser:

```ruby
doc = Nokogiri.XML('<foo><bar /><foo>', nil, 'EUC-JP')
```
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
# Ensuring Well-Formed Markup

## Gentle Well-Formedness

We've all seen bad markup in our day. I'm talking about markup that
doesn't bother to close tags. I'm talking about putting `<p>` tags
inside `<p>` tags, and putting content into an `<img>` tag.

Nokogiri corrects bad markup [like a boss][], similarly to how a browser
would before rendering.

  [like a boss]: http://knowyourmeme.com/memes/like-a-boss

```ruby
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
```
    
And Nokogiri will even keep track of what the errors were, if the
parse option NOERRORS and NOWARNINGS are turned off (the default for
XML documents).

```ruby
puts bad_doc.errors  # => Opening and ending tag mismatch: open line 2 and root
                     #    Premature end of data in tag root line 1
```

Thus, you could use `errors.empty?` to determine whether the document was well-formed.

## Strict Well-Formedness

Being friendly and fixing markup is all well and good, but sometimes
you need to be a [Markup Nazi][soup-nazi].

  [soup-nazi]: http://en.wikipedia.org/wiki/The_Soup_Nazi

If you demand compliance from your XML, then you can configure
Nokogiri into "strict" parsing mode, in which it will raise an
exception at the first sign of malformedness:

```ruby
begin
  bad_doc = Nokogiri::XML(badly_formed) { |config| config.strict }
rescue Nokogiri::XML::SyntaxError => e
  puts "caught exception: #{e}"
end
# => caught exception: Premature end of data in tag root line 1
```
# Getting Help and Reporting Issues

## Halp!

So you're having a great time slicing and dicing your XML with
Nokogiri, and suddenly something happens that you don't quite
understand. O NOES, the good times are over.

What do you do?

## Step 1: Mail [nokogiri-talk][nt], grasshopper.

The best thing to do if you've got a question, or are unsure how to
diagnose a possible issue, want to complain or just ask for advice on
how to solve a problem, is to email the [nokogiri-talk][nt]
list.

The [nokogiri-talk][nt] list has hundreds of subscribers who are all using
nokogiri and who are happy to lend a hand, offer advice, and bail you
out of tricky situations.

In addition, other people may have the same issue or complaint, and so
preserving the question and responses in the mailing list archive is a
gift to future Nokogiri users __just like you__!

### But I want to report a bug!

Step 1 should still be your first step. Mail [nokogiri-talk][nt] first, and
verify that this is really a bug. If there's going to be a
bug-or-not-bug conversation, it's better that it happens transparently
on the list than somewhere hidden, like off-list emails or Github
Issues.

### But I want to verify my issue with the maintainer(s) before I spam the list!

Valid questions and complaints aren't spam! :)

The maintainers vastly prefer nokogiri-related emails to be sent to
[nokogiri-talk][nt] than to their personal accounts. Again, an archive
of discussion has a lot of value. Also, the maintainers may not
respond as quickly as some of the subscribers on the mailing list.

### But I emailed the list and my question hasn't been posted yet!

The [nokogiri-talk][nt] google group is set for first-post moderation,
meaning that the first time you email the list, your post will be held
for review. Once your post is accepted, there won't be any delay on
future emails.

There's _never_ more than a few hour delay on moderation. Thanks for
your patience.

## Step 2: "You got so many [Issues][gi] you need a magazine rack."

So you say you've got a bug. That's great! We always want to increase
the yummy candy-coated goodness of Nokogiri, so if you've got a bug,
we want to hear about it.

We track boogs on [Github Issues][gi], which notifies the maintainers
every time a new ticket is created.

### What's In a Bug Report?

Whoa, do we have strong opinions on this topic. The two most important
things that a bug report needs to contain are:

1. Example code that reproduces the __observed__ behavior.
2. An explanation of what the __expected__ behavior is.

### That's it?

Yes, that's it.

If you're a solid Rubyist, you should be able to provide a **short,
self-contained script** that reproduces and demonstrates the
behavior. [Here's a great example.][issue-with-sample]

If you want to go above-and-beyond, impress the judge from the Czech
Republic, and prove to everyone you went to high school with that
you're better than them, you could even write a **failing unit test**
that meets both criteria in one fell swoop. [Like this
guy.][issue-with-test]

## Summary

To sum up the rules:

1. Mail [nokogiri-talk][nt].
2. No, really, mail [nokogiri-talk][nt].
3. If you're really, absolutely, positively sure you've got a bug AND you can reproduce it, then mail [nokogiri-talk][nt].
4. If you've confirmed it's a bug on [nokogiri-talk][nt], then create a new bug report on [Github Issues][gi] with your repro code and description of expected behavior.

Thanks so much for reading this page! You're a good person, and Nokogiri loves you.

  [nt]: http://groups.google.com/group/nokogiri-talk
  [gi]: http://github.com/sparklemotion/nokogiri/issues
  [issue-with-sample]: http://github.com/sparklemotion/nokogiri/issues/158
  [issue-with-test]: https://github.com/sparklemotion/nokogiri/issues/695
# More Resources

* sax-machine
* feedzirra
* elementor
* mechanize
* markup_validity
