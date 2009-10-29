# Parsing an HTML / XML Document

## From a String

We've tried to make this easy on you. Really! We're here to make your life easier.

    html_doc = Nokogiri::HTML("<html><body><h1>Mr. Belvedere Fan Club</h1></body></html>")
    xml_doc  = Nokogiri::XML("<root><aliens><alien><name>Alf</name></alien></aliens></root>")

The variables `html_doc` and `xml_doc` are Nokogiri documents, which
have all kinds of interesting properties and methods that you [can
read about here][read-document]. We'll cover the interesting bits in other
chapters.

  [read-document]: http://nokogiri.org/Nokogiri/XML/Document.html

## From a File

Note that you don't need to read the file into a string variable. Nokogiri will do this for you.

    f = File.open("blossom.xml")
    doc = Nokogiri::XML(f)
    f.close

Clever Nokogiri! With the time you just saved, approach enlightenment by meditating on [this koan][].

  [this koan]: http://twitter.com/rjw1/status/2741916767

## From the Internets

I understand that there may be some HTML documents available on the
World Wide Web.

    require 'open-uri'
    doc = Nokogiri::XML(open("http://www.threescompany.com/"))

## Parse Options

Nokogiri offers quite a few options that affect how a document is
parsed. You can [read about them here][read-parse-options], but the
most commonly-used options are:

  [read-parse-options]: http://nokogiri.org/Nokogiri/XML/ParseOptions.html

* `NOBLANKS` - Remove blank nodes
* `NOENT` - Substitute entities
* `NOERROR` - Suppress error reports
* `STRICT` - Strict parsing; raise an error when parsing malformed documents

Here's how they are used:

    doc = Nokogiri::XML(File.open("blossom.xml")) do |config|
      config.strict.noent
    end

Or

    doc = Nokogiri::XML(File.open("blossom.xml")) do |config|
      config.options = Nokogiri::XML::ParseOptions.STRICT | Nokogiri::XML::ParseOptions.NOENT
    end

