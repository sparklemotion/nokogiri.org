
# The Official Tutorial Archive™ of Nokogiri ®

These tutorials appear on [nokogiri.org](http://nokogiri.org/) at
[http://nokogiri.org/tutorials](http://nokogiri.org/tutorials).


## How Do I Suggest Opportunities for Improving Documentation?

You could start by emailing
[nokogiri-talk](http://groups.google.com/group/nokogiri-talk).

Or, if you're feeling antisocial, you could just open a [Github
Issue](http://github.com/sparklemotion/nokogiri.org-tutorials/issues).


## How Do I Contribute Documentation?

1. Fork.
2. Edit.
3. Submit pull request.

Please mentally prepare to have your contributions copyedited. Edits
don't mean you're a bad writer, it means that we want the
documentation to have a ["Unity of
Effect"](http://en.wikipedia.org/wiki/The_Philosophy_of_Composition).


## How Do I Edit and View My Changes?

1. `bundle install`
2. Edit markdown files in the `content/` directory.
3. `bundle exec rake html`
4. View generated HTML in the `html/` directory.

### New Chapters

If you want to add a new chapter, make sure you update the file
`content/toc` to contain the title (the first H1) of the
chapter. `toc` is an ordered list.

### Inline Code

Lines starting with `~~~ inline <filename>` are replaced by the file contents in a blockquote.

It's recommended to place anything that's not text into a separate
asset file (so my [bitchin' editor](http://www.gnu.org/software/emacs/)
can use the right mode).

So, if you want to inline any blockquoted content, create a file in
`content/assets` and reference it from the markdown file like so:

    Here's some XML for your entertainment:

    ~~~ inline assets/shows.xml

    And here's some ruby:

    ~~~ inline assets/search-setup.rb

### Live Code with `xmpfilter`

In many places in the docs, ruby code is presented along with its
output
([like here](http://nokogiri.org/tutorials/searching_a_xml_html_document.html)).

When the docs are generated, this ruby code is actually run with the
installed version of nokogiri, and the output is captured!  Wicked
awesome! How does that work?

Lines starting with `~~~ ruby <filename>` are replaced by the output
of running the code in `<filename>` through
[xmpfilter](http://eigenclass.org/hiki.rb?xmpfilter).

So, if you want to inline ruby code and its output, create a file in
`content/assets` and reference it from the markdown file like so:

    Here's some ruby along with its stdout:

    ~~~ ruby assets/search-xpath-characters-first.rb

### Conventions

Don't use inline links. Instead, use footnote-style. Any variation is OK, including blank name:

    Check out [my lolcat][]

      [my lolcat]: http://icanhascheezburger.com/

or a semantic name:

    Check out [this picture of my lolcat][lolcat]

      [lolcat]: http://icanhascheezburger.com/

or an integer:

    Check out [this picture of my lolcat][1]

      [1]: http://icanhascheezburger.com/
