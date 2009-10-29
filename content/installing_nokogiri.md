# Chapter 0: Installing Nokogiri

Because Nokogiri needs to be [compiled][] and [dynamically linked][]
against both [libxml2][] and [libxslt][], it has gained a
reputation for being complicated to install.

  [compiled]: http://en.wikipedia.org/wiki/Compiler
  [dynamically linked]: http://en.wikipedia.org/wiki/Dynamic_linker
  [libxml2]: http://xmlsoft.org/index.html
  [libxslt]: http://xmlsoft.org/xslt/

Let's wrassle this little myth to the ground, shall we?

## Mac OS X

The following should work on both Leopard and Snow Leopard:

    sudo port install libxml2 libxslt
    sudo gem install nokogiri

Please note that Leopard comes bundled with libxml 2.6.16. Someone in
Cupertino is having some fun at our expense, because this MUST be
somebody's idea of a bad joke. 2.6.16 was [released Nov 2004][] and is
really quite buggy. We here at Nokogiri HQ advise *strongly* that you
[do not use this version][].

  [released Nov 2004]: http://mail.gnome.org/archives/xml/2004-November/msg00074.html
  [do not use this version]: http://github.com/tenderlove/nokogiri/blob/master/lib/nokogiri/version_warning.rb#L2

Thankfully, Snow Leopard sensibly comes packaged with libxml 2.7.4.

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

As John Barnette once said, "Isn't package management convenient? :)"

## Red Hat / CentOS

Easy peasy:

    sudo yum install -y libxml2 libmxl2-devel libxslt libxslt-devel
    sudo gem install nokogiri

## Nonstandard libxml2 / libxslt installations

If you've got libxml2 and/or libxslt installed in a nonstandard place
(read as "not /opt/local, /usr/local, /usr or the standard Ruby
directories"), you can use command-line parameters to the `gem
install` command to grease the wheels:

    gem install nokogiri -- --with-xml2-dir=/home/joe/builds --with-xslt-dir=/home/joe/builds

Or, you can specify include and library directories separately:

    gem install nokogiri -- --with-xml2-include=/sw/include/libxml2 --with-xml2-lib=/sw/lib \
      --with-xslt-dir=/sw

## Windows

Luckily for you, building on Windows is so difficult that we've done
it for you: Nokogiri comes bundled with all the DLLs you need to be
NOKOGIRIFIED!

    gem install nokogiri
