# String Encoding, Nokogiri and You: A Primer

## First: A Few Thing To Consider

1. It is common for HTML pages to declare 
1. Without information instructing it differently, Nokogiri's core library ([libxml2][]) will 

  [libxml2]: http://xmlsoft.org/
  [meta-bug]: https://bugzilla.gnome.org/show_bug.cgi?id=579317

useful?: http://www.w3schools.com/XML/xml_encoding.asp


TODO: 
- https://gist.github.com/2fc6c8b3dc42282dc081
- what happens when meta tag says ISO-859-1 and user specifies UTF-8?
- xchat log:
Dec 30 13:47:17 <rnewman>	hi.  how do I get nokogiri to respect the encoding I pass to Nokogiri.parse?
Dec 30 13:47:51 <rnewman>	I do this, and it tells me the string is utf-8, and then the regular expression match fails with an incompatible encoding error:
Dec 30 13:48:00 <rnewman>	url = "http://liberation.fr"
Dec 30 13:48:00 <rnewman>	doc = Nokogiri.parse(open(url), url, "iso-8859-1")
Dec 30 13:48:00 <rnewman>	title = (doc / 'title').text
Dec 30 13:48:00 <rnewman>	puts title
Dec 30 13:48:00 <rnewman>	puts title.encoding
Dec 30 13:48:01 <rnewman>	puts title.gsub(/[èéëê]/, 'e')
Dec 30 13:53:47 <flavorjones>	rnewman: instead of text(), try inner_html()
Dec 30 13:54:52 <flavorjones>	the convention followed is that serialized contents (with to_html, inner_html, etc.) are in the requested encoding ...
Dec 30 13:55:03 <flavorjones>	but .text et al always return utf-8
Dec 30 13:55:58 <rnewman>	but I don't want the whole HTML tag, I just want the text contents.
Dec 30 13:56:26 <rnewman>	(is this documented somewhere that I have missed?)
Dec 30 13:58:21 <rnewman>	I tried changing .text to .first.child.content  but that did not help
Dec 30 13:58:57 <tenderlove>	rnewman: strings returned from nokogiri are always UTF-8
Dec 30 13:59:03 <tenderlove>	I take it you're using ruby 1.9?
Dec 30 14:01:17 <rnewman>	yes, ruby 1.9
Dec 30 14:01:35 <rnewman>	so what does the encoding parameter of Nokogiri.parse() do?  I am very confused.
Dec 30 14:01:35 <tenderlove>	rnewman: okay, cool
Dec 30 14:01:54 *	pauldix (n=pauldix@65.213.72.189) has joined #nokogiri
Dec 30 14:02:02 <tenderlove>	so, the parameter to parse() means that the document you're giving to nokogiri is encoded as iso-8859-1
Dec 30 14:02:09 *	ujihisa (n=ujihisa@S01060003520a5ddd.vc.shawcable.net) has joined #nokogiri
Dec 30 14:02:26 <tenderlove>	no matter what the document you're parsing is encoded as, nokogiri will return strings as utf-8
Dec 30 14:02:37 <tenderlove>	so internally, it converts the iso-8859-1 document to UTF-8
Dec 30 14:03:05 <tenderlove>	since you're using 1.9
Dec 30 14:03:15 <tenderlove>	you can convert the UTF-8 string to whatever encoding you want
Dec 30 14:03:23 <tenderlove>	one sec, and I'll whip up an example
Dec 30 14:04:00 <rnewman>	now suppose I'm using 1.8.[67] instead -- what will nokogiri do?
Dec 30 14:04:15 <tenderlove>	rnewman: even in 1.8, the strings are returned as UTF-8
Dec 30 14:04:27 <tenderlove>	it's just that 1.8 doesn't know about string encodings vs regular expressions
Dec 30 14:04:42 <rnewman>	in 1.8, this doesn't do the substitution and I don't know why:
Dec 30 14:04:42 <rnewman>	puts title.gsub(/[èéëê]/, 'e')
Dec 30 14:05:05 <rnewman>	(I'd like to write a program that works correctly for both 1.8 and 1.9)
Dec 30 14:07:19 <tenderlove>	rnewman: this works in 1.8 and 1.9 https://gist.github.com/d96b037c0a01612cae52
Dec 30 14:07:32 <tenderlove>	probably you needed the magic comment
Dec 30 14:08:13 <rnewman>	I have the magic comment but I don't think it does anything in 1.8
Dec 30 14:08:29 <tenderlove>	no, the magic comment doesn't do anything in 1.8
Dec 30 14:09:27 <flavorjones>	tenderlove, rnewman: that gist outputs differently for me in 1.8 and 1.9:
Dec 30 14:09:45 <flavorjones>	"Toute l'actualitee avec Libeeration" versus "Toute l'actualite avec Liberation"
Dec 30 14:09:56 <flavorjones>	note the doubled 'e' in 1.8
Dec 30 14:10:25 <tenderlove>	flavorjones: ya, that's happening to me too
Dec 30 14:10:25 <tenderlove>	wtf
Dec 30 14:11:28 <tenderlove>	flavorjones, rnewman: here we go: https://gist.github.com/2fc6c8b3dc42282dc081
Dec 30 14:11:34 <tenderlove>	need to tell ruby the regex is UTF-8
Dec 30 14:11:42 <flavorjones>	ah, nice
Dec 30 14:12:15 <flavorjones>	tenderlove: Imma put together a short tutorial on encoding and use this example. mmkey?
Dec 30 14:12:26 <tenderlove>	sounds like a good plan to me
Dec 30 14:12:38 <tenderlove>	we should demonstrate using 1.9
Dec 30 14:12:40 <flavorjones>	do you care if I push straight to heroku? or do you want to be the point man for that
Dec 30 14:12:45 <tenderlove>	since we can show the string encoding easily
Dec 30 14:12:52 <tenderlove>	flavorjones: nope, totally don't care
Dec 30 14:13:03 <flavorjones>	tenderlove: well, I'll try not to f it up
Dec 30 14:13:05 <tenderlove>	in fact, I think we need to push the new docco to heroku anyway
Dec 30 14:15:08 <rnewman>	am trying to use your code; I get:
Dec 30 14:15:18 <rnewman>	encoding-test.rb:7:in `<main>': undefined local variable or method ` ' for main:Object (NameError)
Dec 30 14:17:38 <tenderlove>	rnewman: are you actually checking out the gist, or did you copy and paste?
Dec 30 14:19:18 <rnewman>	just copied and pasted.
Dec 30 14:19:44 <tenderlove>	can you try cloning the gist and running from there?
Dec 30 14:19:52 <tenderlove>	I just want to make sure there are no copy-paste errors
Dec 30 14:20:04 <rnewman>	i don't know what 'clone the gist' or 'checking out the gist' means.
Dec 30 14:20:15 <tenderlove>	hmmm
Dec 30 14:20:16 <tenderlove>	okay
Dec 30 14:20:29 <rnewman>	I just copied and pasted from the 'raw' link.
Dec 30 14:20:43 <tenderlove>	what OS are you on?
Dec 30 14:20:49 <rnewman>	Leopard
Dec 30 14:21:18 <rnewman>	this is all pretty new to me.   it should be simple but seems to be very confusing.
Dec 30 14:21:32 <tenderlove>	dealing with encodings is confusing
Dec 30 14:21:40 <tenderlove>	try this:
Dec 30 14:21:45 <tenderlove>	curl https://gist.github.com/raw/2fc6c8b3dc42282dc081/8ffe609c9057c043c2595151e2d5a724cd536eba/gistfile1.txt > foo.rb
Dec 30 14:21:56 <tenderlove>	then run foo.rb
Dec 30 14:22:22 *	cwalcott (n=cwalcott@209-20-65-112.slicehost.net) has joined #nokogiri
Dec 30 14:23:42 <rnewman>	it printed this (in 1.9.1):
Dec 30 14:23:43 <rnewman>	{"Toute l'actualité avec Libération"=>"Toute l'actualité avec Libération"}
Dec 30 14:23:51 <rnewman>	that doesn't look right to me
Dec 30 14:24:38 <tenderlove>	what is the output of "nokogiri -v" ?
Dec 30 14:25:06 <rnewman>	nokogiri: 1.4.1
Dec 30 14:25:06 <rnewman>	libxml:
Dec 30 14:25:06 <rnewman>	  binding: extension
Dec 30 14:25:06 <rnewman>	  compiled: 2.7.3
Dec 30 14:25:06 <rnewman>	  loaded: 2.7.3
Dec 30 14:25:38 <tenderlove>	huh
Dec 30 14:25:38 <rnewman>	in 1.8.7 I had to do ruby -r rubygems foo.rb, and I got this:
Dec 30 14:25:46 <rnewman>	{"Toute l'actualit\303\203\302\251 avec Lib\303\203\302\251ration"=>"Toute l'actualit\303\203\302\251 avec Lib\303\203\302\251ration"}
Dec 30 14:26:03 <tenderlove>	flavorjones: any ideas?
Dec 30 14:28:23 <tenderlove>	rnewman: I'm not sure what the difference between our machines is.  Something is different on your box than on mine.
Dec 30 14:30:50 *	stepheneb (n=stephene@otrunk/stepheneb) has joined #nokogiri
Dec 30 14:34:49 *	ujihisa_ (n=ujihisa@S01060003520a5ddd.vc.shawcable.net) has joined #nokogiri
Dec 30 14:35:37 <rnewman>	so i'm not understanding what i am doing wrong here or what I should try next.
Dec 30 14:36:12 <tenderlove>	I don't think you're doing anything wrong.
Dec 30 14:36:17 <tenderlove>	I'm at a loss for next steps
Dec 30 14:36:27 <tenderlove>	that code does what you want on my machine with 1.8 and 1.9
Dec 30 14:36:37 <tenderlove>	seems that way for flavorjones too
Dec 30 14:36:49 <tenderlove>	so there must be a difference in our environments that I don't know about
Dec 30 14:38:25 *	serabe (n=sergio@89.131.182.39) has joined #nokogiri
Dec 30 14:38:28 <serabe>	hi
Dec 30 14:38:36 <tenderlove>	serabe: hey
Dec 30 14:38:51 <rnewman>	what should I look at ?
Dec 30 14:39:13 *	ujihisa has quit (Read error: 60 (Operation timed out))
Dec 30 14:39:57 <tenderlove>	rnewman: I'm not sure.  You're running libxml2 that's a couple revisions behind, but I don't think that's the problem
Dec 30 14:40:51 <tenderlove>	rnewman: what does "locale" say?
Dec 30 14:41:42 <rnewman>	$ locale
Dec 30 14:41:42 <rnewman>	LANG="en_US.UTF-8"
Dec 30 14:41:42 <rnewman>	LC_COLLATE="en_US.UTF-8"
Dec 30 14:41:42 <rnewman>	LC_CTYPE="en_US.UTF-8"
Dec 30 14:41:42 <rnewman>	LC_MESSAGES="en_US.UTF-8"
Dec 30 14:41:43 <rnewman>	LC_MONETARY="en_US.UTF-8"
Dec 30 14:41:45 <rnewman>	LC_NUMERIC="en_US.UTF-8"
Dec 30 14:41:47 <rnewman>	LC_TIME="en_US.UTF-8"
Dec 30 14:41:49 <rnewman>	LC_ALL=
Dec 30 14:41:51 <rnewman>	$ locale
Dec 30 14:41:53 <rnewman>	LANG="en_US.UTF-8"
Dec 30 14:41:55 <rnewman>	LC_COLLATE="en_US.UTF-8"
Dec 30 14:41:57 <rnewman>	LC_CTYPE="en_US.UTF-8"
Dec 30 14:41:59 <rnewman>	LC_MESSAGES="en_US.UTF-8"
Dec 30 14:42:01 <rnewman>	LC_MONETARY="en_US.UTF-8"
Dec 30 14:42:03 <rnewman>	LC_NUMERIC="en_US.UTF-8"
Dec 30 14:42:05 <rnewman>	LC_TIME="en_US.UTF-8"
Dec 30 14:42:07 <rnewman>	LC_ALL=
Dec 30 14:42:09 <rnewman>	$ locale
Dec 30 14:42:11 <rnewman>	LANG="en_US.UTF-8"
Dec 30 14:42:13 <rnewman>	LC_COLLATE="en_US.UTF-8"
Dec 30 14:42:15 <rnewman>	LC_CTYPE="en_US.UTF-8"
Dec 30 14:42:16 <tenderlove>	uh
Dec 30 14:42:17 <rnewman>	LC_MESSAGES="en_US.UTF-8"
Dec 30 14:42:19 <rnewman>	LC_MONETARY="en_US.UTF-8"
Dec 30 14:42:21 <rnewman>	LC_NUMERIC="en_US.UTF-8"
Dec 30 14:42:23 <rnewman>	LC_TIME="en_US.UTF-8"
Dec 30 14:42:25 <rnewman>	LC_ALL=
Dec 30 14:42:27 <rnewman>	oops, sorry for the repeat
Dec 30 14:43:40 <tenderlove>	that's all the same as mine
Dec 30 14:45:42 <rnewman>	I added in p title.chars.to_a and p title.bytes.to_a (before the gsub) and got:
Dec 30 14:45:56 <rnewman>	["T", "o", "u", "t", "e", " ", "l", "'", "a", "c", "t", "u", "a", "l", "i", "t", "Ã", "©", " ", "a", "v", "e", "c", " ", "L", "i", "b", "Ã", "©", "r", "a", "t", "i", "o", "n"]
Dec 30 14:45:56 <rnewman>	[84, 111, 117, 116, 101, 32, 108, 39, 97, 99, 116, 117, 97, 108, 105, 116, 195, 131, 194, 169, 32, 97, 118, 101, 99, 32, 76, 105, 98, 195, 131, 194, 169, 114, 97, 116, 105, 111, 110]
Dec 30 14:47:09 <tenderlove>	oh!
Dec 30 14:47:16 <tenderlove>	that's helpful!
Dec 30 14:47:17 <tenderlove>	okay
Dec 30 14:47:36 <rnewman>	(obviously that will only work in 1.9)
Dec 30 14:48:47 <tenderlove>	rnewman: try changing this Nokogiri::HTML(open(url))
Dec 30 14:48:52 <tenderlove>	to this: Nokogiri::HTML(open(url), url, 'UTF-8')
Dec 30 14:49:18 <rnewman>	will do so now.    utf-8 is not the default then?
Dec 30 14:49:47 <tenderlove>	not for html
Dec 30 14:49:57 <tenderlove>	html spec says ISO-8859-1
Dec 30 14:50:03 <tenderlove>	:-(
Dec 30 14:50:34 <rnewman>	but ... the html of that page says:  <meta http-equiv="content-type" content="text/html; charset=UTF-8" />
Dec 30 14:51:07 <rnewman>	(and that still doesn't explain why it worked for you without the 'UTF-8" parameter)
Dec 30 14:52:18 <rnewman>	in ruby 1.9.1 your revised script works correctly.
Dec 30 14:52:24 <rnewman>	however in ruby 1.8.7 I get:
Dec 30 14:52:31 <rnewman>	"Toute l'actualit\303\251 avec Lib\303\251ration"
Dec 30 14:52:31 <rnewman>	"Toute l'actualitee avec Libeeration"
Dec 30 14:54:08 <tenderlove>	rnewman: I suspect the meta tag problem is a bug in libxml2 (I recall submitting a patch for that)
Dec 30 14:54:23 <tenderlove>	does your script have the "u" switch on the regex?
Dec 30 14:54:45 *	stepheneb has quit ()
Dec 30 14:54:48 <rnewman>	oops, i took it out while expeimenting ... let me put it back right now and try again.
Dec 30 14:56:04 <rnewman>	much better now.   so the answer seems to be (a) always specify 'UTF-8' explicitly to Nokogiri.parse;  (b) always use the /u switch in regex if I have accented characters in the regex
Dec 30 14:56:54 <rnewman>	if I don't specify a character encoding to Nokogirl.parse then you say  it ignores the meta tag and always uses ISO-8859-1 instead of UTF-8 ?
Dec 30 14:57:57 <tenderlove>	rnewman: no, it doesn't always do that.  It will use the meta tag
Dec 30 14:58:24 <tenderlove>	but there was a bug if libxml2 saw non iso-8859-1 characters before the meta tag
Dec 30 14:58:30 <tenderlove>	it would try to guess then encoding
Dec 30 14:58:40 <tenderlove>	then ignore what the meta tag says
Dec 30 14:59:10 <rnewman>	and that page has a <head> tag with accented chars before the <meta> tag.
Dec 30 15:00:18 <rnewman>	now ... is this all still going to work for a page whose declared encoding is ISO-8859-1 instead of utf-8 ?
Dec 30 15:00:42 <tenderlove>	that is a good question.  I don't know
Dec 30 15:00:55 <rnewman>	(as this started with my trying to read pages at http://extension.harvard.edu with professor names that have accented chars, and those pages are iso-8859-1)
Dec 30 15:01:43 <tenderlove>	huh, http://www.extension.harvard.edu/default.jsp has a meta tag that says UTF-8
Dec 30 15:01:50 <rnewman>	it would be good if you can put advice on the nokogiri website for how to write a program that is portable between ruby 1.8.[67] and 1.9.1 when multi-byte chars are involved.
Dec 30 15:02:11 <tenderlove>	ya, that's what flavorjones and I were just talking about
Dec 30 15:02:13 <flavorjones>	rnewman: we discussed that about an hour ago
Dec 30 15:02:31 <flavorjones>	i'm going to be borrowing heavily from this conversation and put together a tutorial on nokogiri.org
Dec 30 15:02:55 <rnewman>	but http://www.extension.harvard.edu/2009-10/about/faculty/a_c.jsp has iso-8859-1
Dec 30 15:02:57 <tenderlove>	flavorjones: we need to figure out the behavior wrt specifying an encoding vs the encoding in the meta tag
Dec 30 15:03:09 <flavorjones>	tenderlove: indeed. i thought that was a libxml2 bug
Dec 30 15:03:24 <tenderlove>	flavorjones: I think rnewman is seeing a libxml2 bug
Dec 30 15:03:29 <flavorjones>	ya
Dec 30 15:03:45 <tenderlove>	but we need to know what happens when a user specifies UTF-8 and the meta tag declares ISO-8859-1
Dec 30 15:03:45 <rnewman>	i'm using the libxml2 from XAMPP which is more recent than the one that came with Leopard.
Dec 30 15:03:47 <flavorjones>	libxml2's meta tag handling is pretty brittle all around
Dec 30 15:04:07 <flavorjones>	tenderlove: ya, i'll do a matrix of libxml2 and ruby versions and figure out what happens
Dec 30 15:04:16 <tenderlove>	IMO, the behavior should be to always use what the user specifies
Dec 30 15:04:19 <rnewman>	when I used the Leopard one, your basic example on your home page did not work.
Dec 30 15:04:41 <tenderlove>	rnewman: the Leopard version is ~5 years old
Dec 30 15:04:52 <tenderlove>	we're hoping to drop support for it soon
Dec 30 15:04:59 <flavorjones>	fingers crossed
Dec 30 15:05:52 <tenderlove>	foods.  bbiab
