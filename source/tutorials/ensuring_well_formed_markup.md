---
title: Ensuring well-formed markup
layout: page
sidebar: false
---
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
