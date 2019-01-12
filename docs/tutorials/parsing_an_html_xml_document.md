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

  [read-document]: https://nokogiri.org/rdoc/Nokogiri/XML/Document

## From a File

Note that you don't need to read the file into a string variable. Nokogiri will do this for you.

```ruby
doc = File.open("blossom.xml") { |f| Nokogiri::XML(f) }
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
parsed; you can read about them in the [XML::ParseOptions docs][read-parse-options].

Notably, Nokogiri will treat input as untrusted documents by default, thereby avoiding a class of vulnerabilities known as [XXE][XXE] or "XML eXternal Entity" processing. What this means is that Nokogiri won't attempt to load external DTDs or access the network for any external resources.

Some commonly-used [parse options][read-parse-options] are:

  [read-parse-options]: https://nokogiri.org/rdoc/Nokogiri/XML/ParseOptions
  [XXE]: https://www.owasp.org/index.php/XML_External_Entity_(XXE)_Processing

* `NONET` - Prevent any network connections during parsing. Recommended for parsing untrusted documents. __This is set by default!__
* `RECOVER` - Attempt to recover from errors. Recommended for parsing malformed or invalid documents. __This is set by default!__
* `NOBLANKS` - Remove blank nodes
* `NOENT` - Substitute entities
* `NOERROR` - Suppress error reports
* `STRICT` - Strict parsing; raise an error when parsing malformed documents
* `DTDLOAD` and `DTDVALID` - If you want DTD validation
* `HUGE` - use to skip hardcoded limits around document size or DOM depth; comes with a performance penalty

You _could_ use them by handcrafting an artisanal bitmap (not recommended):

```ruby
doc = Nokogiri::XML(File.open("blossom.xml")) do |config|
  config.options = Nokogiri::XML::ParseOptions::STRICT | Nokogiri::XML::ParseOptions::NOBLANKS
end
```

But it's more idiomatic to use the chainable shortcuts on the config object instead:

```ruby
doc = Nokogiri::XML(File.open("blossom.xml")) do |config|
  config.strict.noblanks
end
```

Notably, if you want to turn _off_ an option that's set by default, you can prefix a "no" to the config shortcut:

```ruby
doc = Nokogiri::XML(File.open("blossom.xml")) do |config|
  config.norecover
end
```

Leading to the perhaps-surprising (but logical!) `nononet` to turn networking back on:

``` ruby
doc = Nokogiri::XML(File.open("blossom.xml")) do |config|
  config.nononet
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
