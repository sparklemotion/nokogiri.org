# Chapter 1: Parsing an HTML / XML Document

## From a String

We've tried to make this easy on you. Really! We're here to make your life easier.

    html_doc = Nokogiri::HTML.parse("<html><body><h1>Mr. Belvedere Fan Club</h1></body></html>")
    xml_doc  = Nokogiri::XML.parse("<root><aliens><alien><name>Alf</name></alien></aliens></root>")

The variables `html_doc` and `xml_doc` are Nokogiri documents, which
have all kinds of interesting properties and methods that you [can
read about here][]. We'll cover the interesting bits in other
chapters.

  [can read about here]: http://nokogiri.org/Nokogiri/XML/Document.html

## From a File

Note that you don't need to read the file into a string variable. Nokogiri will do this for you.

    doc = Nokogiri::XML(File.open("tree.xml"))

Clever Nokogiri!

## From the Internets

I understand that there may be some HTML documents available on the
World Wide Web.

    require 'open-uri'
    doc = Nokogiri::XML(open("http://www.threescompany.com/"))

