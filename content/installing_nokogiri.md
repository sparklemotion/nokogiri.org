# Installing Nokogiri

Because Nokogiri needs to be [compiled][] and [dynamically linked][]
against both [libxml2][] and [libxslt][], it has gained a
reputation for being complicated to install.

  [compiled]: http://en.wikipedia.org/wiki/Compiler
  [dynamically linked]: http://en.wikipedia.org/wiki/Dynamic_linker
  [libxml2]: http://xmlsoft.org/index.html
  [libxslt]: http://xmlsoft.org/xslt/

Let's wrassle this little myth to the ground, shall we?

## Mac OS X

Please note that Leopard comes bundled with libxml 2.6.16. Someone in
Cupertino MUST be having some fun at our expense, because this is
clearly somebody's idea of a bad joke. 2.6.16 was [released Nov
2004][] and is really quite buggy. We here at Nokogiri HQ advise
*strongly* that you [do not use this version][].

  [released Nov 2004]: http://mail.gnome.org/archives/xml/2004-November/msg00074.html
  [do not use this version]: http://github.com/tenderlove/nokogiri/blob/master/lib/nokogiri/version_warning.rb#L2

Sensibly, Snow Leopard comes packaged with libxml 2.7.3, but you're
probably using either macports or homebrew to manage your dev
packages, so Read On, True Believer!

### macports

    sudo port install libxml2 libxslt
    sudo gem install nokogiri

### homebrew

    # the rest of this snippet assumes installation of libxml 2.7.7. YMMV.
    brew install libxml2
    brew link libxml2
    
    # install libxslt from source
    wget ftp://xmlsoft.org/libxml2/libxslt-1.1.26.tar.gz
    tar -zxvf libxslt-1.1.26.tar.gz
    cd libxslt-1.1.26
    ./configure --prefix=/usr/local/Cellar/libxslt/1.1.26 \
                --with-libxml-prefix=/usr/local/Cellar/libxml2/2.7.7
    make
    sudo make install
    
    gem install nokogiri -- --with-xslt-dir=/usr/local/Cellar/libxslt/1.1.26
    
## Ubuntu / Debian

Ubuntu doesn't come with the Ruby development packages that are
required for building gems with C extensions. Here are the commands to
install everything you might need:

    # ruby developer packages
    sudo apt-get install ruby1.8-dev ruby1.8 ri1.8 rdoc1.8 irb1.8
    sudo apt-get install libreadline-ruby1.8 libruby1.8 libopenssl-ruby

    # nokogiri requirements
    sudo apt-get install libxslt-dev libxml2-dev
    sudo gem install nokogiri

Although, if you're using Hardy (8.04) or earlier, you'll need to install slightly different packages:

    # nokogiri requirements for Hardy (8.04) and earlier
    sudo apt-get install libxslt1-dev libxml2-dev

As [John Barnette once said][package-management], "Isn't package management convenient? :)"

  [package-management]: http://rubyforge.org/pipermail/nokogiri-talk/2009-March/000181.html

## Red Hat / CentOS

In theory, this is easy peasy:

    sudo yum install -y libxml2 libxml2-devel libxslt libxslt-devel
    sudo gem install nokogiri

In practice, though, CentOS 5 (and RHEL5) come installed with libxml 2.6.26
which, while not as offensively out-of-date as Mac Leopard, is still
pretty damn old ([released June 2006][]) and has [known][] [issues][].

If you're affected by any known bugs or are seeing odd behavior, you
may want to consider uninstalling the RPMs for libxml2 and libxslt,
and building them from source.

  [released June 2006]: http://mail.gnome.org/archives/xml/2006-June/msg00043.html
  [known]: http://github.com/tenderlove/nokogiri/issues#issue/243
  [issues]: http://github.com/tenderlove/nokogiri/issues#issue/122

 1. `sudo yum remove -y libxml2-devel libxslt-devel`
 2. download the most recent libxml2 and libxslt from [ftp://xmlsoft.org/libxml2/](ftp://xmlsoft.org/libxml2/)
 3. `./configure ; make ; sudo make install`

Then install nokogiri specifying the libxml2 and libxslt install directories:

    sudo gem install nokogiri -- --with-xml2-lib=/usr/local/lib \
                                 --with-xml2-include=/usr/local/include/libxml2 \
                                 --with-xslt-lib=/usr/local/lib \
                                 --with-xslt-include=/usr/local/include

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

    gem install nokogiri -- --with-xml2-dir=/home/joe/builds \
                            --with-xslt-dir=/home/joe/builds

Or, you can specify include and library directories separately:

    gem install nokogiri -- --with-xml2-lib=/home/joe/builds/lib \
                            --with-xml2-include=/home/joe/builds/include/libxml2 \
                            --with-xslt-lib=/home/joe/builds/lib \
                            --with-xslt-include=/home/joe/builds/include

Note that, by default, libxslt header files are installed into the
root include directory, but libxml2 header files are installed into a
subdirectory thereof named `libxml2`.

## Windows

Luckily for you, building on Windows is so difficult that we've done
it for you: Nokogiri comes bundled with all the DLLs you need to be
NOKOGIRIFIED!

    gem install nokogiri
