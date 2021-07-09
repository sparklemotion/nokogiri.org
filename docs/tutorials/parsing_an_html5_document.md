# Parsing an HTML5 Document

Nokogiri provides the ability for a Ruby program to invoke [our version of the Gumbo HTML5
parser](https://github.com/sparklemotion/nokogiri/tree/master/gumbo-parser/src) and to access the
result as a
[Nokogiri::HTML::Document](http://rdoc.info/github/sparklemotion/nokogiri/Nokogiri/HTML/Document).

!!! question "Why is HTML5 parsing covered as a separate tutorial from [HTML parsing](/tutorials/parsing_an_html_xml_document.html)?"

    Eventually, we'll integrate HTML5 docs into the other of tutorials, and this page will go away. We
    shipped HTML5 support as quickly as possible by copying (and only lightly editing) the Nokogumbo
    documentation to this page.

!!! info "HTML5 support is only in v1.12.0 and later."

    This tutorial describes functionality that is only available in Nokogiri v1.12.0 and later. Please
    visit the [HTML5 API documentation](/rdoc/Nokogiri/HTML5.html) for more information.

!!! warning "HTML5 functionality is not available when running JRuby."

    The JRuby implementation of Nokogiri does not support HTML5 as of v1.12.0. If you'd like to help
    implement this support, or would like to know more, please see
    [#2227](https://github.com/sparklemotion/nokogiri/issues/2227).


## Usage

Parse an HTML5 document:

``` ruby
doc = Nokogiri.HTML5(string)
```

Parse an HTML5 fragment:

``` ruby
fragment = Nokogiri::HTML5.fragment(string)
```

## Parsing options

The document and fragment parsing methods support options that are different from Nokogiri's.

- `Nokogiri.HTML5(html, url = nil, encoding = nil, options = {})`
- `Nokogiri::HTML5.parse(html, url = nil, encoding = nil, options = {})`
- `Nokogiri::HTML5::Document.parse(html, url = nil, encoding = nil, options = {})`
- `Nokogiri::HTML5.fragment(html, encoding = nil, options = {})`
- `Nokogiri::HTML5::DocumentFragment.parse(html, encoding = nil, options = {})`

The three currently supported options are `:max_errors`, `:max_tree_depth` and
`:max_attributes`, described below.


### Error reporting

Nokogiri contains an experimental HTML5 parse error reporting facility. By default, no parse errors
are reported but this can be configured by passing the `:max_errors` option to
[HTML5.parse](/rdoc/Nokogiri/HTML5.html#parse-class_method) or
[HTML5.fragment](/rdoc/Nokogiri/HTML5.html#fragment-class_method).

For example, this script:

``` ruby
doc = Nokogiri::HTML5.parse('<span/>Hi there!</span foo=bar />', max_errors: 10)
doc.errors.each do |err|
  puts(err)
end
```

Emits:

``` text
1:1: ERROR: Expected a doctype token
<span/>Hi there!</span foo=bar />
^
1:1: ERROR: Start tag of nonvoid HTML element ends with '/>', use '>'.
<span/>Hi there!</span foo=bar />
^
1:17: ERROR: End tag ends with '/>', use '>'.
<span/>Hi there!</span foo=bar />
                ^
1:17: ERROR: End tag contains attributes.
<span/>Hi there!</span foo=bar />
                ^
```

Using `max_errors: -1` results in an unlimited number of errors being returned.

The [HTML standard](https://html.spec.whatwg.org/multipage/parsing.html#parse-errors) defines a
number of standard parse error codes. These error codes only cover the "tokenization" stage of
parsing HTML. The parse errors in the "tree construction" stage do not have standardized error
codes (yet).

As a convenience to Nokogiri users, the defined error codes are available via
`Nokogiri::XML::SyntaxError#str1` method:

``` ruby
doc = Nokogiri::HTML5.parse('<span/>Hi there!</span foo=bar />', max_errors: 10)
doc.errors.each do |err|
  puts("#{err.line}:#{err.column}: #{err.str1}")
end
# => 1:1: generic-parser
#    1:1: non-void-html-element-start-tag-with-trailing-solidus
#    1:17: end-tag-with-trailing-solidus
#    1:17: end-tag-with-attributes
```

Note that the first error is `generic-parser` because it's an error from the tree construction
stage and doesn't have a standardized error code.

For the purposes of semantic versioning, the error messages, error locations, and error codes
are not part of Nokogiri's public API. That is, these are subject to change without Nokogiri's
major version number changing. These may be stabilized in the future.

### Maximum tree depth

The maximum depth of the DOM tree parsed by the various parsing methods is configurable by the
`:max_tree_depth` option. If the depth of the tree would exceed this limit, then an
`::ArgumentError` is thrown.

This limit (which defaults to `Nokogiri::Gumbo::DEFAULT_MAX_TREE_DEPTH = 400`) can be removed
by giving the option `max_tree_depth: -1`.

``` ruby
html = '<!DOCTYPE html>' + '<div>' * 1000
doc = Nokogiri.HTML5(html)
# raises ArgumentError: Document tree depth limit exceeded
doc = Nokogiri.HTML5(html, max_tree_depth: -1)
```

### Attribute limit per element

The maximum number of attributes per DOM element is configurable by the `:max_attributes`
option. If a given element would exceed this limit, then an `::ArgumentError` is thrown.

This limit (which defaults to `Nokogiri::Gumbo::DEFAULT_MAX_ATTRIBUTES = 400`) can be removed
by giving the option `max_attributes: -1`.

``` ruby
html = '<!DOCTYPE html><div ' + (1..1000).map { |x| "attr-#{x}" }.join(' ') + '>'
# "<!DOCTYPE html><div attr-1 attr-2 attr-3 ... attr-1000>"
doc = Nokogiri.HTML5(html)
# raises ArgumentError: Attributes per element limit exceeded
doc = Nokogiri.HTML5(html, max_attributes: -1)
```

## HTML Serialization

After parsing HTML, it may be serialized using any of the `Nokogiri::XML::Node` serialization
methods. In particular, `XML::Node#serialize`, `#to_html`, and `#to_s` will
serialize a given node and its children. (This is the equivalent of JavaScript's
`Element.outerHTML`.) Similarly, `XML::Node#inner_html` will serialize the children of a given
node. (This is the equivalent of JavaScript's `Element.innerHTML`.)

``` ruby
doc = Nokogiri::HTML5("<!DOCTYPE html><span>Hello world!</span>")
puts doc.serialize
# => <!DOCTYPE html><html><head></head><body><span>Hello world!</span></body></html>
```

## Notes

* The `Nokogiri::HTML5.fragment` function takes a string and parses it
  as a HTML5 document.  The `<html>`, `<head>`, and `<body>` elements are
  removed from this document, and any children of these elements that remain
  are returned as a `Nokogiri::HTML5::DocumentFragment`.

* The `Nokogiri::HTML5.parse` function takes a string and passes it to the
  <code>gumbo_parse_with_options</code> method, using the default options.
  The resulting Gumbo parse tree is then walked.

* Instead of uppercase element names, lowercase element names are produced.

* Instead of returning `unknown` as the element name for unknown tags, the
  original tag name is returned verbatim.
