# Installing Nokogiri

Because Nokogiri needs to be [compiled][] and [dynamically linked][]
against both [libxml2][] and [libxslt][], it has gained a
reputation for being complicated to install.

  [compiled]: http://en.wikipedia.org/wiki/Compiler
  [dynamically linked]: http://en.wikipedia.org/wiki/Dynamic_linker
  [libxml2]: http://xmlsoft.org/index.html
  [libxslt]: http://xmlsoft.org/xslt/

Let's wrassle this little myth to the ground, shall we?
In ascending order of difficulty ...

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

```sh
gem install nokogiri
```

Please note that at this time, building Nokogiri with DevKit may work,
but is unsupported. If you feel strongly that this should be
supported, we'd love to talk about it on `nokogiri-talk`!


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

### Troubleshooting

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
gem install nokogiri -- --use-system-libraries
    [--with-xml2-config=/path/to/xml2-config]
    [--with-xslt-config=/path/to/xslt-config]
```

or, you can specify the installation root directory:

```sh
gem install nokogiri -- --use-system-libraries
    [--with-xml2-dir=/path/to/dir]
    [--with-xslt-dir=/path/to/dir]
```

or, you can specify include and library directories separately:

```sh
gem install nokogiri -- --with-xml2-lib=/path/to/builds/lib \
                        --with-xml2-include=/path/to/builds/include/libxml2 \
                        --with-xslt-lib=/path/to/builds/lib \
                        --with-xslt-include=/path/to/builds/include
```

N.B.: By default, libxslt header files are installed into the
root include directory, but libxml2 header files are installed into a
subdirectory thereof named `libxml2`.
  [Getting Help]: http://www.nokogiri.org/tutorials/getting_help.html
