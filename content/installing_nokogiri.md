# Installing Nokogiri

Because Nokogiri needs to be [compiled][] and [dynamically linked][]
against both [libxml2][] and [libxslt][], it has gained a
reputation for being complicated to install.

  [compiled]: http://en.wikipedia.org/wiki/Compiler
  [dynamically linked]: http://en.wikipedia.org/wiki/Dynamic_linker
  [libxml2]: http://xmlsoft.org/index.html
  [libxslt]: http://xmlsoft.org/xslt/

As of Nokogiri 1.6, `libxml2` and `libxslt` source code is bundled
with Nokogiri, and compiled at gem-install-time. This document should
work for all versions 1.6.4 and later.

(If you need support for installing earlier versions of Nokogiri, you
may want to take a look at the git history for [this document][].)

  [this document]: https://github.com/sparklemotion/nokogiri.org-tutorials/blob/master/content/installing_nokogiri.md

Let's tackle each platform and scenario in ascending order of difficulty ...

## Ubuntu / Debian

Installation should Just Work™ on Ubuntu and Debian using Nokogiri's
vendored `libxml2` and `libxslt`:

```sh
gem install nokogiri
```

Please report it as a bug if this doesn't work for you (see
[Getting Help][] for details).


## Windows

Luckily for you, building on Windows is so difficult that we've done
it for you: Nokogiri comes bundled with all the DLLs you need to be
NOKOGIRIFIED!

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


### Troubleshooting Windows Installation

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
[this thread][windows-platform-thread] for background). Please update
to Rubygems 2.4.5 or later and everything should work.

  [windows-platform-thread]: https://groups.google.com/d/msg/nokogiri-talk/BJiwiebHxoQ/B3vgV4iE9g0J


### Compiling natively on Windows

Please note that at this time, building Nokogiri with DevKit __may__
work, but is unsupported. If you feel strongly that this should be
supported, we'd love to talk about it.

We've currently (as of 2015-01-18) got an open
[Github Issue][windows-native-builds] to discuss this topic, please
join in!

  [windows-native-builds]: https://github.com/sparklemotion/nokogiri/issues/1190


## Red Hat / CentOS

The easiest way to get Nokogiri installed on CentOS and RHEL seems to be the
[EPEL][] repository which contains a prebuilt nokogiri package. To use it,
install the appropriate [epel-release][] package for your OS, then run:

```sh
sudo yum install -y rubygem-nokogiri
```

  [EPEL]: http://fedoraproject.org/wiki/EPEL
  [epel-release]: http://fedoraproject.org/wiki/EPEL#How_can_I_use_these_extra_packages.3F


However, installation of the regular gem should Just Work™ using
Nokogiri's vendored `libxml2` and `libxslt`:

```sh
gem install nokogiri
```

If you have issues, make sure you have some of the basic Ruby
developer tools that you'll need to compile the C extension,
`libxml2`, and `libxslt`:

```sh
sudo yum install -y gcc ruby-devel
```

Please report it as a bug if this doesn't work for you (see
[Getting Help][] for details).


## Mac OS X

Most developers are using homebrew to manage their packages these
days. If you are, you're in luck.

### homebrew 0.9.5+

Installation should Just Work™ using Nokogiri's vendored `libxml2` and
`libxslt`:

```sh
gem install nokogiri
```

However, you may need to jump through some hoops around `libiconv` ... (see next section)

### Troubleshooting OSX Installation

#### "I'm on a virginal Yosemite installation."

Team Nokogiri has reproduced an issue with brand-spanking-new Yosemite
installations, which can be corrected by running:

```sh
gem update --system
```

Ya, really. >_< (Thanks to @zenspider for looking into this one.)


#### "I see error messages about libiconv."

If you have problems mentioning libiconv missing that looks something like this:

    Installing nokogiri (1.6.4) Building nokogiri using packaged libraries.

    Gem::Installer::ExtensionBuildError: ERROR: Failed to build gem native extension.

        /usr/local/rvm/rubies/ruby-2.0.0-p0/bin/ruby extconf.rb
    Building nokogiri using packaged libraries.
    checking for iconv.h... yes
    checking for iconv_open() in iconv.h... no
    checking for iconv_open() in -liconv... no
    checking for libiconv_open() in iconv.h... no
    checking for libiconv_open() in -liconv... no
    -----
    libiconv is missing.  please visit http://nokogiri.org/tutorials/installing_nokogiri.html for help with installing dependencies.
    -----
    *** extconf.rb failed ***

Then you are probably missing the right developer tools. This is a really easy fix:

```sh
brew unlink gcc-4.2      # you might not need this step
gem uninstall nokogiri
xcode-select --install
gem install nokogiri
```

This is verified working on OSX 10.9 w/ xcode's clang compiler.

(Many thanks to @allaire and others for helping verify this!)


### Other OS X tips

* Make sure ruby is compiled with the latest clang compiler.
* Ruby is no longer dependent upon gcc-4.2.
* Binary gems and ruby really should be compiled with the same compiler/environment.
* If you have multiple versions of xcode installed, make sure you use the right xcode-select.

If you have any other issues, please file an issue (preferably a new
one, read [Getting Help][] for details) and pull in @zenspider.

  [Getting Help]: http://www.nokogiri.org/tutorials/getting_help.html


## Using Your System Libraries

If, instead of Nokogiri's vendored libraries, you'd like to use your
system's `libxml2`, `libxslt` and related libraries, please first
understand that you may be asking Nokogiri to work with an unsupported
version of `libxml2`. We try hard to warn you about this; and will
even refuse to compile against some known-bad versions of `libxml2`.

But, we want to give you the flexibility to choose this option.

Here's how to ignore Nokogiri's vendored libraries and use your
installed system libraries (assuming they're installed somewhere
reasonable, like /opt/local, /usr/local, /usr or the standard Ruby
directories):

```sh
gem install nokogiri -- --use-system-libraries
```

Or, if you're using Bundler:

```sh
bundle config build.nokogiri --use-system-libraries
bundle install
```


## Using Nonstandard libxml2 / libxslt installations

If you've got libxml2 and/or libxslt installed in a nonstandard place
(read as "not /opt/local, /usr/local, /usr or the standard Ruby
directories"), you can use command-line parameters to the `gem
install` command to grease the wheels.

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


## Other

Don't see your platform here? We'd love to add to this
document. Please feel free to send pull requests to
[sparklemotion/nokogiri.org-tutorials][].

  [sparklemotion/nokogiri.org-tutorials]: https://github.com/sparklemotion/nokogiri.org-tutorials
