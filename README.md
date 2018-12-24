# nokogiri.org

## The Official Tutorial Archive™ of Nokogiri®

These documents and tutorials appear on [nokogiri.org][].


## How Do I Suggest Opportunities for Improving Documentation?

You could start by emailing [nokogiri-talk][].

Or, if you're feeling less chatty, you could just open a [Github Issue][].


## What needs to be documented? I'd like to help.

Take a look at the [open issues][]!


## How Do I Contribute Documentation? How Do I Edit and View My Changes?

1. Fork this repository.
2. `bundle install` and `bundle exec rake dev:setup`
3. Edit the files in `docs/` (and note that some files exist in subdirectories like `docs/tutorials/`.
4. `bundle exec rake preview` to spin up a mkdocs server to host the site locally.
5. Submit a pull request.

We use `[mkdocs][]` to generate the static files for the site, which are pretty fancy and include a search capability.

Note that files in `docs/` are preprocessed (see below) and placed into `staging/` along with some files from Nokogiri's repository, so editing files in `docs/` won't update live in the mkdocs server.


### Inline Code or Files

Lines starting with `~~~ inline <filename>` are replaced by the file contents in a blockquote.

It's recommended to place anything that's not text into a separate asset file (so my [classy editor][] can use the right mode).

So, if you want to inline any blockquoted content, create a file in `docs/assets` and reference it from the markdown file like so:

    Here's some XML for your entertainment:

    ~~~ inline assets/shows.xml

    And here's some ruby:

    ~~~ inline assets/search-setup.rb


### Live Code with `xmpfilter`

In many places in the docs, ruby code is presented along with its output, like in [this example][example doc].

When the docs are generated, this ruby code is actually run with the installed version of nokogiri, and the output is captured!  Wicked awesome! How does that work?

Lines starting with `~~~ ruby <filename>` are replaced by the output of running the code in `<filename>` through __[xmpfilter][]__.

So, if you want to inline ruby code and its output, create a file in `docs/assets` and reference it from the markdown file like so:

    Here's some ruby along with its stdout:

    ~~~ ruby assets/search-xpath-characters-first.rb


### Adding New Chapters

If you want to add a new chapter, make sure you update the file `mkdocs.yml` so it appears in the nav bar.


### Conventions / Style Guide

Don't use inline links. Instead, use footnote-style links (like you can see in this document's raw format). Any variation is OK, including blank name:

    Check out [my lolcat][]

      [my lolcat]: http://icanhascheezburger.com/


or a semantic name:

    Check out [this picture of my lolcat][lolcat]

      [lolcat]: http://icanhascheezburger.com/


or an integer:

    Check out [this picture of my lolcat][1]

      [1]: http://icanhascheezburger.com/


Just please don't do this:

    Check out my [lolcat](https://www.youtube.com/watch?v=dQw4w9WgXcQ)


Thank you!



<!-- markdown links below here -->

  [nokogiri.org]: http://nokogiri.org/
  [nokogiri-talk]: http://groups.google.com/group/nokogiri-talk
  [Github Issue]: https://github.com/sparklemotion/nokogiri.org/issues
  [open issues]: https://github.com/sparklemotion/nokogiri.org/issues
  [mkdocs]: https://www.mkdocs.org/
  [classy editor]: http://www.gnu.org/software/emacs/
  [example doc]: http://nokogiri.org/tutorials/searching_a_xml_html_document.html
  [xmpfilter]: https://github.com/rcodetools/rcodetools
