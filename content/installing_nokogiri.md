# Installing Nokogiri

Because Nokogiri needs to be [compiled][] and [dynamically linked][]
against both [libxml2][] and [libxslt][], it has gained a
reputation for being complicated to install.

  [compiled]: http://en.wikipedia.org/wiki/Compiler
  [dynamically linked]: http://en.wikipedia.org/wiki/Dynamic_linker
  [libxml2]: http://xmlsoft.org/index.html
  [libxslt]: http://xmlsoft.org/xslt/

Let's wrassle this little myth to the ground, shall we?

## Ubuntu / Debian

Installation should Just Work™ on Ubuntu and Debian using Nokogiri's
vendored `libxml2` and `libxslt`:

```sh
gem install nokogiri
```

Please report it as a bug if this doesn't work for you (see
[Getting Help][] for details).

  [Getting Help]: http://www.nokogiri.org/tutorials/getting_help.html


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

  [Getting Help]: http://www.nokogiri.org/tutorials/getting_help.html


## Red Hat / CentOS

The easiest way to get Nokogiri installed on CentOS and RHEL seems to be the
[EPEL][] repository which contains a prebuilt nokogiri package. To use it,
install the appropriate [epel-release][] package for your OS, then run:

```sh
sudo yum install -y rubygem-nokogiri
```

  [EPEL]: http://fedoraproject.org/wiki/EPEL
  [epel-release]: http://fedoraproject.org/wiki/EPEL#How_can_I_use_these_extra_packages.3F

To install using gem install is somewhat more complicated because of the age of
the packages available from the central repositories. If you have rubygems
installed, you may be able to install nokogiri via `gem install`. If you run
intro problems, try installing these packages as well.

```sh
sudo yum install -y gcc ruby-devel libxml2 libxml2-devel libxslt libxslt-devel
```

CentOS 5 (and RHEL5) come installed with libxml 2.6.26 which, while not as
offensively out-of-date as Mac Leopard, is still pretty damn old ([released
June 2006][]) and has [known][] [issues][].

If you're affected by any known bugs or are seeing odd behavior, you
may want to consider uninstalling the RPMs for libxml2 and libxslt,
and building them from source.

  [released June 2006]: http://mail.gnome.org/archives/xml/2006-June/msg00043.html
  [known]: http://github.com/sparklemotion/nokogiri/issues#issue/243
  [issues]: http://github.com/sparklemotion/nokogiri/issues#issue/122

 1. `sudo yum remove -y libxml2-devel libxslt-devel`
 2. download the most recent libxml2 and libxslt from [ftp://xmlsoft.org/libxml2/](ftp://xmlsoft.org/libxml2/)
 3. `./configure ; make ; sudo make install`

Then install nokogiri specifying the libxml2 and libxslt install directories:

```sh
sudo gem install nokogiri -- --with-xml2-lib=/usr/local/lib \
                             --with-xml2-include=/usr/local/include/libxml2 \
                             --with-xslt-lib=/usr/local/lib \
                             --with-xslt-include=/usr/local/include
```

(Note that, by default, libxslt header files are installed into the
root include directory, but libxml2 header files are installed into a
subdirectory thereof named `libxml2`.)

Or, you know, whatever directories into which you installed libxml and
libxslt. Good luck.


## Nonstandard libxml2 / libxslt installations

If you've got libxml2 and/or libxslt installed in a nonstandard place
(read as "not /opt/local, /usr/local, /usr or the standard Ruby
directories"), you can use command-line parameters to the `gem
install` command to grease the wheels:

```sh
gem install nokogiri -- --with-xml2-dir=/home/joe/builds \
                        --with-xslt-dir=/home/joe/builds
```

Or, you can specify include and library directories separately:

```sh
gem install nokogiri -- --with-xml2-lib=/home/joe/builds/lib \
                        --with-xml2-include=/home/joe/builds/include/libxml2 \
                        --with-xslt-lib=/home/joe/builds/lib \
                        --with-xslt-include=/home/joe/builds/include
```

Note that, by default, libxslt header files are installed into the
root include directory, but libxml2 header files are installed into a
subdirectory thereof named `libxml2`.


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
