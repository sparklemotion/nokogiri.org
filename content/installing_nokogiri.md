# Installing Nokogiri

Because Nokogiri needs to be [compiled][] and [dynamically linked][]
against both [libxml2][] and [libxslt][], it has gained a
reputation for being complicated to install.

As of Nokogiri 1.6, `libxml2` and `libxslt` source code is bundled
with Nokogiri, and compiled at gem-install-time. The instructions in
this document should work for all versions 1.6.4 and later.

(If you need support for installing earlier versions of Nokogiri, you
may want to take a look at the git history for [this document][].)

Let's tackle each platform and scenario in ascending order of difficulty ...

  [compiled]: http://en.wikipedia.org/wiki/Compiler
  [dynamically linked]: http://en.wikipedia.org/wiki/Dynamic_linker
  [libxml2]: http://xmlsoft.org/index.html
  [libxslt]: http://xmlsoft.org/xslt/
  [this document]: https://github.com/sparklemotion/nokogiri.org-tutorials/blob/master/content/installing_nokogiri.md


## Ubuntu / Debian

Installation should Just Work™ on Ubuntu and Debian using Nokogiri's
vendored `libxml2` and `libxslt`:

```sh
gem install nokogiri
```

### Troubleshooting Ubuntu / Debian Installation

If you have issues, first make sure you have all the tooling necessary
to compile C extensions:

```sh
sudo apt-get install build-essential patch
```

It's possible that you don't have important development header files
installed on your system. (This has never happened to me personally,
but I have it on good authority that otherwise good and noble Ruby
developers run into this.) Here's what you should do if you should
find yourself in this situation:

```sh
sudo apt-get install ruby-dev zlib1g-dev liblzma-dev
```

Please report it as a bug if this doesn't work for you (see
[Getting Help][] for details).


### Troubleshooting RVM-based Installation

Some versions of RVM will install a Ruby binary that requires
libgmp. See https://github.com/rvm/rvm/issues/3509 for background.

So, if your `mkmf.log` file says:

```sh
/usr/bin/ld: cannot find -lgmp
```

then try this:

```sh
sudo apt-get install libgmp-dev
```

Please report it as a bug if this doesn't work for you (see
[Getting Help][] for details).


## FreeBSD

Installation should Just Work™ on FreeBSD using Nokogiri's
vendored `libxml2` and `libxslt`:

```sh
gem install nokogiri
```

## Windows

### Option 1: Precompiled DLLs ("fat binary")

Compiling on Windows requires the installation of special build tools,
and so as an alternative we provide a pre-compiled Nokogiri gem that
comes bundled with all the DLLs you need to be NOKOGIRIFIED!

Specifically, we publish gems specific for the Windows "platform", as
it's called by Rubygems. For example, [Nokogiri 1.6.5][] published:

* [nokogiri-1.6.5-x64-mingw32.gem][]
* [nokogiri-1.6.5-x86-mingw32.gem][]

for the 64-bit and 32-bit Rubyinstaller rubies, respectively.

This __should__ Just Work™:

```sh
gem install nokogiri
```

  [Nokogiri 1.6.5]: https://rubygems.org/gems/nokogiri/versions/1.6.5
  [nokogiri-1.6.5-x64-mingw32.gem]: https://rubygems.org/downloads/nokogiri-1.6.5-x64-mingw32.gem
  [nokogiri-1.6.5-x86-mingw32.gem]: https://rubygems.org/downloads/nokogiri-1.6.5-x86-mingw32.gem


### Option 2: Native Windows compilation

As of Nokogiri 1.6.7, [DevKit][] compilation of Nokogiri is fully
supported.

If you don't know what DevKit is, or if you're using an earlier
version of Nokogiri than 1.6.7, you should not try to follow this
process, and should instead install a gem with precompiled DLLs using
__Option 1__ above.

  [DevKit]: http://rubyinstaller.org/add-ons/devkit/


### Troubleshooting Native Windows compilation

If you see this error:

```
ERROR:  Error installing nokogiri:
        The 'nokogiri' native gem requires installed build tools.

Please update your PATH to include build tools or download the DevKit
from 'http://rubyinstaller.org/downloads' and follow the instructions
at 'http://github.com/oneclick/rubyinstaller/wiki/Development-Kit'
```

or you see something like this error:

```
Extracting libiconv-1.14.tar.gz into tmp/i686-pc-mingw32/ports/libiconv/1.14... OK
Running 'configure' for libiconv 1.14... ERROR, review
'C:/RailsInstaller/.../nokogiri-1.6.5/.../libiconv/1.14/configure.log'
to see what happened.
*** extconf.rb failed ***
Could not create Makefile due to some reason, probably lack of necessary
libraries and/or headers.  Check the mkmf.log file for more details.  You may
need configuration options.
```

then you may be runing a buggy version of Rubygems that's not
downloading the appropriate gemfile for your platform (see
[this thread][windows-platform-thread] for background). __Please update
to Rubygems 2.4.5 or later for the fix__.

Please report it as a bug if this doesn't work for you (see
[Getting Help][] for details).

  [windows-platform-thread]: https://groups.google.com/d/msg/nokogiri-talk/BJiwiebHxoQ/B3vgV4iE9g0J


## Red Hat / CentOS

The easiest way to get Nokogiri installed on CentOS and RHEL seems to be the
[EPEL][] repository which contains a prebuilt nokogiri package. To use it,
install the appropriate [epel-release][] package for your OS, then run:

```sh
sudo yum install -y rubygem-nokogiri
```

However, installation of the regular gem should Just Work™ using
Nokogiri's vendored `libxml2` and `libxslt`:

```sh
gem install nokogiri
```

  [EPEL]: http://fedoraproject.org/wiki/EPEL
  [epel-release]: http://fedoraproject.org/wiki/EPEL#How_can_I_use_these_extra_packages.3F


### Troubleshooting Red Hat / CentOS Installation

If you have issues, make sure you have some of the basic Ruby
developer tools that you'll need to compile the C extension,
`libxml2`, and `libxslt`:

It's also possible that you don't have the zlib development header
files installed on your system.

This has never happened to me personally, but I have it on good
authority that otherwise good and noble Ruby developers run into this.

```sh
sudo yum install -y gcc ruby-devel zlib-devel
```

In newer versions of Fedora and Red Hat, you may see an error like:

```
gcc: error: /usr/lib/rpm/redhat/redhat-hardened-cc1: File or directory doesn't exists
```

in which case you'll also need rpm to build nokogiri:

```
sudo dnf install -y rpm-build
```

Please report it as a bug if this doesn't work for you (see
[Getting Help][] for details).

## GNU Guix

[GNU Guix](https://www.gnu.org/software/guix/) is a reproducible
binary software package management and distribution system that works
on *all* Linux distributions. Installing Nokogiri with

```sh
guix package -i ruby-nokogiri
```

will install Nokogiri with tool and libraries and all its dependencies
(including a recent Ruby, libxml2 and libxslt). The source code for
the package can be found [here](http://git.savannah.gnu.org/cgit/guix.git/tree/gnu/packages/ruby.scm). A short description of how Nokogiri was packaged can be found
[here](https://github.com/pjotrp/guix-notes/blob/master/RUBYGEMS-Nokogiri.org).


## Mac OS X

Installation should Just Work™ using Nokogiri's vendored `libxml2` and `libxslt`.

First, make sure you have the latest version of RubyGems and xcode commandline tools:

```sh
gem update --system
xcode-select --install
```

Then install nokogiri:

```sh
gem install nokogiri
```

### Troubleshooting OSX Installation

#### Error Message About `libiconv` Missing

If you get an error message saying that `libiconv` is missing, the fix is
ensuring that you have the right developer tools selected, or the license has
been accepted.

```
Building nokogiri using packaged libraries.
checking for iconv.h... yes
checking for iconv_open() in iconv.h... no
checking for iconv_open() in -liconv... no
checking for libiconv_open() in iconv.h... no
checking for libiconv_open() in -liconv... no
-----
libiconv is missing. please visit http://nokogiri.org/tutorials/installing_nokogiri.html for help with installing dependencies.
-----
*** extconf.rb failed ***
```

The fix is really easy:

```sh
brew unlink gcc-4.2      # you might not need this step
gem uninstall nokogiri
xcode-select --install
gem install nokogiri
```

This is verified working on Mac OS X 10.9 w/ Xcode's clang compiler.

(Many thanks to @allaire and others for helping verify this!)


##### `xcode-select` errors with a 'network problem'

If, when you run the above commands, you see this dialog:

![xcode-select-network-problem](../assets/xcode-select-network-problem.png)

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

1.  For some people, the `xcode-select` solution presented under the
    [`libiconv`](#error-message-about-libiconv-missing) issue above works.
    Generally, this works only when Xcode or macOS has recently been upgraded
    and the Xcode licence has not yet been accepted.

2.  When using Homebrew, there are several libraries that use a formula called
    `xz` (including `the_silver_searcher` and `imagemagick`), which by default
    installs a version of `liblzma` that is incompatible with most Ruby builds.
    (Homebrew installs only the 64-bit version of the library, but most Ruby
    builds are universal.) This can be fixed in a couple of ways:

    a.  The most reliable way appears to be temporarily unlinking `xz` and
        relinking it during an install of `nokogiri`:

        ```sh
        brew unlink xz
        gem install nokogiri # or bundle install
        brew link xz
        ```

    b.  The second way that has been reported having success is to install `xz`
        as a universal build:

        ```sh
        brew reinstall xz --universal
        ```

    c.  The third way is to use a Homebrew-installed `libxml2`, as suggested in
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

### Other macOS Tips

*   Make sure ruby is compiled with the latest clang compiler.
*   Ruby is no longer dependent upon `gcc-4.2`.
*   Binary gems and ruby really should be compiled with the same
    compiler/environment.
*   If you have multiple versions of Xcode installed, make sure you use the
    right `xcode-select`.

If you have any other issues, please report it as a bug (preferably a new one,
read [Getting Help][] for details) and pull in @zenspider.

## Using Your System Libraries

If, instead of Nokogiri's vendored libraries, you'd like to use your
system's `libxml2`, `libxslt` and related libraries, please first
understand that you may be asking Nokogiri to work with an unsupported
version of `libxml2`. We try hard to warn you about this; and will
even refuse to compile against some known-bad versions of `libxml2`.

But, we want to give you the flexibility to choose this option.

Here's how to use your installed system libraries instead of the
vendored libraries:


### Step 1: Make sure you have `pkg-config` installed

Everything should Just Work™ if you have `pkg-config` installed.

On Debian/Ubuntu:

```
sudo apt-get install pkg-config
```

On FreeBSD:

```
sudo pkg install pkgconf
```


### Step 2: Build Nokogiri

```sh
gem install nokogiri -- --use-system-libraries
```

Or, if you're using Bundler:

```sh
bundle config build.nokogiri --use-system-libraries
bundle install
```


### Using Your System Libraries with Nokogiri >= 1.6.0, < 1.6.2

Nokogiri did not support the CLI argument `--use-system-libraries`
before v1.6.2. If you are trying to use system libraries with an
earlier version of Nokogiri, use the `NOKOGIRI_USE_SYSTEM_LIBRARIES`
environment variable instead:

```sh
NOKOGIRI_USE_SYSTEM_LIBRARIES=1 gem install nokogiri
```

Or, if you're using Bundler:

```sh
export NOKOGIRI_USE_SYSTEM_LIBRARIES=1
bundle install
```


## Using Nonstandard libxml2 / libxslt installations

If:

* you've got libxml2 and/or libxslt installed in a nonstandard place,
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

N.B.: By default, libxslt header files are installed into the
root include directory, but libxml2 header files are installed into a
subdirectory thereof named `libxml2`.

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

### And how to tell Bundler to use custom parameters

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

Some versions of bundler have a bug (bundler/bundler#3053) that causes
the options to be sent improperly, resulting in a `Syntax error:
Unterminated quoted string` error.  The workaround is to edit your
`.bundle/config` file, remove the quotes around the options, and place
all the options on a single line.


## SmartOS (Nonstandard)

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


## Other

Don't see your platform here? We'd love to add to this
document. Please feel free to send pull requests to
[sparklemotion/nokogiri.org-tutorials][].

  [sparklemotion/nokogiri.org-tutorials]: https://github.com/sparklemotion/nokogiri.org-tutorials

  [Getting Help]: http://www.nokogiri.org/tutorials/getting_help.html
