# Installing Nokogiri

Nokogiri includes its own updated and patched copies of [libxml2][] and
[libxslt][] libraries. By default, installation of Nokogiri will use
these copies. Alternatively, you may install using your operating system's
built-in libraries or other custom versions of these libraries.

*This document also helps with common problems we've heard. If you have an
issue not discussed here, please
[open an issue](https://github.com/sparklemotion/nokogiri.org-tutorials/issues).*

*For earlier versions of Nokogiri, find instructions in
[the git history for this document](https://github.com/sparklemotion/nokogiri.org-tutorials/blob/master/content/installing_nokogiri.md).*

*For other platforms, please send pull requests to 
[sparklemotion/nokogiri.org-tutorials][].*

  [sparklemotion/nokogiri.org-tutorials]: https://github.com/sparklemotion/nokogiri.org-tutorials
  [libxml2]: http://xmlsoft.org/
  [libxslt]: http://xmlsoft.org/libxslt/

---

## Install with included libraries (RECOMMENDED)

### Ubuntu / Debian

Install Nokogiri on a brand new Ubuntu system with these commands:

```sh
sudo apt-get install build-essential patch ruby-dev zlib1g-dev liblzma-dev
gem install nokogiri
```

*Note for RVM users: [you may require libgmp](https://github.com/rvm/rvm/issues/3509), consider running `sudo apt-get install libgmp-dev`.*

### FreeBSD / OpenBSD >= 6.2

Install Nokogiri on a brand new FreeBSD system with these commands:

```sh
gem install nokogiri
```

### OpenBSD < 6.2

Use `gcc` from ports in order to compile the included libraries:

```sh
pkg_add -v gcc
gem install nokogiri
```

### Windows

Use Rubyinstaller to install our binary distribution in a flash!

```sh
gem install nokogiri
```

Or build using [DevKit][]. This is an advanced option you should only
try if you know what you're doing. You MUST use Rubygems 2.4.5 or later.

  [DevKit]: http://rubyinstaller.org/add-ons/devkit/

Also see more details on this advanced procedure on [this nokogiri-talk thread](https://groups.google.com/d/msg/nokogiri-talk/BJiwiebHxoQ/B3vgV4iE9g0J).

### Red Hat / CentOS

Install Nokogiri on a brand new Red Had / CentOS system with these commands:

```sh
sudo yum install -y gcc ruby-devel zlib-devel
# sudo dnf install -y rpm-build # This may be required
gem install nokogiri
```

Alternatively, you may install the appropriate [epel-release][] and get the
Nokogiri package from [EPEL][] using:

```sh
sudo yum install -y rubygem-nokogiri
```

  [EPEL]: http://fedoraproject.org/wiki/EPEL
  [epel-release]: http://fedoraproject.org/wiki/EPEL#How_can_I_use_these_extra_packages.3F

### GNU Guix

Install on any Linux distribution using [GNU Guix](https://www.gnu.org/software/guix/),
a reproducible binary software package management and distribution system.

Use this command:

```sh
guix package -i ruby-nokogiri
```

*Note: source code is available [here](http://git.savannah.gnu.org/cgit/guix.git/tree/gnu/packages/ruby.scm). A short description of how Nokogiri was packaged can be found
[here](https://github.com/pjotrp/guix-notes/blob/master/RUBYGEMS-Nokogiri.org).*

### Ruby on Alpine Linux (Docker)

[The official ruby-alpine Docker images](https://hub.docker.com/_/ruby/) are
stripped of their development tools to minimize size. To install nokogiri (or
other gems with native extensions) you'll need to install build tools again via
the [`build-base` meta-package](https://pkgs.alpinelinux.org/package/edge/main/x86_64/build-base)
(which includes gcc and other necessities).

```Dockerfile
FROM ruby:2.6-alpine

RUN apk add --no-cache build-base
RUN gem install nokogiri
```

### TermUX

Although TermUX isn't fully supported right now, some people have reported success getting Nokogiri installed on it by running these commands:

``` sh
pkg install ruby clang make pkg-config libxslt
gem install nokogiri -- --use-system-libraries
```


### macOS

First, make sure you have the latest version of RubyGems and xcode commandline tools:

```sh
gem update --system
xcode-select --install # Then agree to the terms, even if you have done this before!
```

Then install nokogiri:

```sh
gem install nokogiri
```

*This is verified working on maxOS 10.9 w/ Xcode's clang compiler. (Many thanks to @allaire and others for helping!)*

#### `xcode-select` errors with a 'network problem'

If, you see this dialog when you run the above commands:

![xcode-select-network-problem](images/xcode-select-network-problem.png)

Then run this command to turn off forced-authentication with Apple Software
Update:

```sh
sudo defaults delete /Library/Preferences/com.apple.SoftwareUpdate CatalogURL
```

#### Error Message About Undeclared Identifier `LZMA_OK`

A more recent error mentions an undeclared identifier `LZMA_OK`:

```
xmlIO.c:1450:52: error: use of undeclared identifier 'LZMA_OK'
    ret =  (__libxml2_xzclose((xzFile) context) == LZMA_OK ) ? 0 : -1;
                                                   ^
1 error generated.
```

The solution for this is a little more subtle and can be fixed in a couple of
ways.

1.  When using Homebrew, there are several libraries that use a formula called
    `xz` (including `the_silver_searcher` and `imagemagick`), which by default
    install a version of `liblzma` that is incompatible with most Ruby builds.
    (Homebrew installs only the 64-bit version of the library, but most Ruby
    builds are universal.) This can be fixed in a couple of ways:

    a.  The most reliable way appears to be temporarily unlinking `xz` and
        relinking it during an install of `nokogiri`:

        ```sh
        brew unlink xz
        gem install nokogiri # or bundle install
        brew link xz
        ```

    b.  The third way is to use a Homebrew-installed `libxml2`, as suggested in
        [using your system libraries](#using-your-system-libraries).

        ```sh
        brew install libxml2
        # If installing directly
        gem install nokogiri -- --use-system-libraries \
          --with-xml2-include=$(brew --prefix libxml2)/include/libxml2
        # If using Bundle
        bundle config build.nokogiri --use-system-libraries \
          --with-xml2-include=$(brew --prefix libxml2)/include/libxml2
        bundle install
        ```

        When working with this, be certain to use `$(brew --prefix libxml2)`
        because it will use the correct location for your Homebrew install.

#### Unable to find libraries on macOS Mojave

Xcode 10 on macOS Mojave [moves the system headers][xcode10] out of `/usr/include`
and so Nokogiri will fail to build. Instead you'll see an error similar to this:

```sh
Building nokogiri using packaged libraries.
-----
libiconv is missing.  please visit http://nokogiri.org/tutorials/installing_nokogiri.html for help with installing dependencies.
-----
*** extconf.rb failed ***
Could not create Makefile due to some reason, probably lack of necessary libraries and/or headers.
```

A temporary workaround to allow previous releases of Nokogiri to build is to
install the extra headers package mentioned in the Xcode 10 release notes:

```sh
open /Library/Developer/CommandLineTools/Packages/macOS_SDK_headers_for_macOS_10.14.pkg
```

[xcode10]: https://developer.apple.com/documentation/xcode_release_notes/xcode_10_release_notes#3035624

#### Other macOS Tips

*   Make sure ruby is compiled with the latest clang compiler.
*   Binary gems and ruby should be compiled with the same compiler/environment.
*   If you have multiple versions of Xcode installed, make sure you use the
    right `xcode-select`.
*   Try [installing with system libraries](#install_with_system_libraries).

*If reporting an issue about the macOS installation instructions, please mention @zenspider.*

---

## Install with system libraries

Nokogiri will refuse to build against certain versions of `libxml2`, `libxslt`
supplied with your operating system, and certain versions will cause mysterious
problems. The compile scripts will warn you if you try to do this.

### Step 1: Install `pkg-config`

On Debian/Ubuntu:

```
sudo apt-get install pkg-config
```

On FreeBSD:

```
sudo pkg install pkgconf
```

### Step 2: Build Nokogiri

Using gem:

```sh
gem install nokogiri -- --use-system-libraries
```

Or, use Bundler:

```sh
bundle config build.nokogiri --use-system-libraries
bundle install
```


---

## Install with custom / non-standard libraries

If:

* you've got `libxml2` and/or `libxslt` installed in a nonstandard place,
* and you don't have `pkg-config` installed

you can use command-line parameters to the `gem install` command to
specify build parameters.

If you've got the proper `config` scripts:

```sh
gem install nokogiri -- \
    --use-system-libraries \
    --with-xml2-config=/path/to/xml2-config \
    --with-xslt-config=/path/to/xslt-config
```

or, you can specify the installation root directory:

```sh
gem install nokogiri -- \
    --use-system-libraries \
    --with-xml2-dir=/path/to/dir \
    --with-xslt-dir=/path/to/dir
```

or, you can specify include and library directories separately:

```sh
gem install nokogiri -- \
    --use-system-libraries \
    --with-xml2-lib=/path/to/builds/lib \
    --with-xml2-include=/path/to/builds/include/libxml2 \
    --with-xslt-lib=/path/to/builds/lib \
    --with-xslt-include=/path/to/builds/include
```

*Note: By default, libxslt header files are installed into the
root include directory, but libxml2 header files are installed into a
subdirectory thereof named `libxml2`.*

It's likely that you'll also need to specify the location of your
`zlib` and `iconv` (and possibly `exslt`) install directories as
well. In that case, you can add the options:

```sh
gem install nokogiri -- \
    --use-system-libraries \
    # ...
    --with-iconv-dir=/path/to/dir \
    --with-zlib-dir=/path/to/dir \
    [--with-exslt-dir=/path/to/dir]
    [--with-exslt-config=/path/to/exslt-config]
```

### How to tell Bundler to use custom parameters

```
bundle config build.nokogiri \
       --use-system-libraries \
       --with-xml2-lib=/usr/local/lib \
       --with-xml2-include=/usr/local/include/libxml2/libxml \
       --with-xslt-lib=/usr/local/lib \
       --with-xslt-include=/usr/local/include/libxslt \
       --with-iconv-lib=/usr/local/lib \
       --with-iconv-include=/usr/local/include
```

Do not attempt Bundler installation using Bundler versions before v1.8.3.
See [bundler/bundler#3053](https://github.com/bundler/bundler/issues/3053). But if you really want to,
see earlier git history of this file, which includes a workaround.

### Ruby on Alpine Linux (Docker)

To compile against Alpine's own XML libraries, add the necessary
development tools and libraries to the image.

``` Dockerfile
FROM ruby:2.6-alpine

RUN apk add --no-cache build-base libxml2-dev libxslt-dev
RUN gem install nokogiri -- --use-system-libraries
```

When optimizing the size of an Alpine image, the runtime libraries
must be permanently added. Additionally, adding and removing
development tooling can be chained with gem installation to ensure a
small layer.

```Dockerfile
FROM ruby:2.6-alpine

RUN apk add --no-cache libxml2 libxslt && \
        apk add --no-cache --virtual .gem-installdeps build-base libxml2-dev libxslt-dev && \
        gem install nokogiri -- --use-system-libraries && \
        rm -rf $GEM_HOME/cache && \
        apk del .gem-installdeps
```

This approach nets an 12.1 MB layer (versus 18.1 MB without `--use-system-libraries`)
and saves over 170 MB in build tools.

### SmartOS (Nonstandard)

SmartOS installation requires building and using
libxml2/libxslt/libiconv in a nonstandard location. Building on the
previous section, here's how to do it:

(Note: `pkgsrc` is included in JPC SmartOS instances)

```sh
pkgin install ruby gcc49 libxml2 libxslt zlib libiconv ruby22-rake gmake
ln -s /opt/local/gcc49/bin/gcc /opt/local/bin/gcc

gem install nokogiri -- \
    --use-system-libraries \
    --with-xml2-lib=/opt/local/lib \
    --with-xml2-include=/opt/local/include/libxml2 \
    --with-xslt-lib=/opt/local/lib \
    --with-xslt-include=/opt/local/include/libxslt \
    --with-iconv-lib=/opt/local/lib \
    --with-iconv-include=/opt/local/include \
    --with-zlib-dir=/opt/local/lib
```

See the previous section for guidance on how to instruct Bundler to
use these options.
