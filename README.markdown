# Nokogiri.org

This is the source for the Nokogiri website
[nokogiri.org](http://nokogiri.org).

It's the presentation layer for the tutorials content at
[github.com/sparklemotion/nokogiri.org-tutorials](https://github.com/sparklemotion/nokogiri.org-tutorials)


## Installation

Nokogiri.org is built with [Octopress](http://octopress.org/), a
[Jekyll](http://jekyllrb.com/) framework.

To run this site locally:

1. `git submodule update --init`
2. `bundle install`
3. `bundle exec rake tutorials`

and then refer to the Octopress commands output by `rake -T` to see
options, including:

```
rake generate   # Generates posts and pages into the public directory
rake watch      # Watches source/ and sass/ for changes and regenerates
rake preview    # Watches, and mounts a webserver at http://localhost:4000
```

## Troubleshooting/Contributing

To contribute to the tutorials, please visit [github.com/sparklemotion/nokogiri.org-tutorials](https://github.com/sparklemotion/nokogiri.org-tutorials). Pull requests accepted!

To contribute to the this site, please send a pull request.

Also, you may want to check out the Nokogiri guide to [contributing](http://nokogiri.org/tutorials/getting_help.html).


## License

(The MIT License)

Copyright © 2008 - 2014:

- Aaron Patterson
- Mike Dalessio
- Charles Nutter
- Sergio Arbeo
- Patrick Mahoney
- Yoko Harada
- Akinori MUSHA
- Kristian Freeman

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

