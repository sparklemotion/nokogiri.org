# Searching an HTML / XML Document

Let's suppose you have the following document:

    # shows.xml
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
      <dramas>
    </root>

Let's further suppose that you want a list of all the characters in
all the shows in this document.

    doc = Nokogiri::XML(File.open("shows.xml"))
    characters = doc.xpath("//character")
    # => <character>Al Bundy</character>
         <character>Bud Bundy</character>
         <character>Marcy Darcy</character>
         <character>Larry Appleton</character>
         <character>Balki Bartokomous</character>
         <character>John "Hannibal" Smith</character>
         <character>Templeton "Face" Peck</character>
         <character>"B.A." Baracus</character>
         <character>"Howling Mad" Murdock</character>

The variable `characters` is actually a [NodeSet][], which acts very much
like an array, and contains matching nodes from the document.

  [NodeSet]: http://nokogiri.org/Nokogiri/XML/NodeSet.html

    characters[0]  # => <character>Al Bundy</character>

You can use any XPath or CSS query you like (see the chapter on XPath
and CSS syntax for more information).

    doc.xpath("//dramas//character")
    # => <character>John "Hannibal" Smith</character>
         <character>Templeton "Face" Peck</character>
         <character>"B.A." Baracus</character>
         <character>"Howling Mad" Murdock</character>

Notably, you can even use CSS queries in an XML document!

    doc.css("sitcoms name")
    # => <name>Married with Children</name>
         <name>Perfect Strangers</name>

CSS queries are often the easiest and most succinct way to express
what you're looking for, so don't be afraid to use them!
