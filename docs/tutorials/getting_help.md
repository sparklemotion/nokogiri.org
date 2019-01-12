# Getting Help and Reporting Issues

## [Halp!](https://www.urbandictionary.com/define.php?term=halp)

So you're having a great time slicing and dicing your XML with
Nokogiri, and suddenly something happens that you don't quite
understand. O NOES, the good times are over.

What do you do?


## Step 1: Is it a security vulnerability?

If you intend to report a security vulnerability, please do so at [HackerOne][h1] following the process detailed in [`SECURITY.md`](https://nokogiri.org/SECURITY.html). __Do not report security vulnerabilities through GitHub or email.__


## Step 2: Mail [nokogiri-talk][nt], grasshopper.

The best thing to do if you've got a question, or are unsure how to diagnose a possible issue, want to complain, or just ask for advice on how to solve a problem, is to email the [nokogiri-talk][nt] list.

The [nokogiri-talk][nt] list has hundreds of subscribers who are all using nokogiri and who are happy to lend a hand, offer advice, and bail you out of tricky situations.

In addition, other people may have the same issue or complaint, and so preserving the question and responses in the mailing list archive is a gift to future Nokogiri users __just like you__!

You should also probably **subscribe** to the list. You can either use the [web interface][nt]; or if you're like RMS and hate to use javascripty things like Google's web interface, you can subscribe to the list by sending an empty email to `nokogiri-talk+subscribe@googlegroups.com`

Please do not mail the maintainers at their personal addresses.


### But I emailed the list and my question hasn't been posted yet!

The [nokogiri-talk][nt] google group is set for "first-post moderation" for non-members, meaning that the first time you email the list, your post will be held for review. Once your post is accepted, there won't be any delay on future emails.

You can avoid first-post moderation by joining the google group (as described above).


## Step 3: Bug reporting

If you're sure you've got a bug and don't need to talk about it, that's great! We always want to make Nokogiri better, so if you've got a bug, we want to hear about it.

We track bugs on [Github Issues][gi], which notifies the maintainers every time a new ticket is created.


### What's In a Bug Report?

Whoa, do we have strong opinions on this topic. The two most important things that a bug report needs to contain are:

1. Example code that reproduces the __observed__ behavior.
2. An explanation of what the __expected__ behavior is.

If possible, please include a complete, self-contained script that reproduces the behavior you're seeing. Please try to remove external dependencies like Rails or other libraries that may be wrapping Nokogiri.

Here's an example of how you might structure such a script:

```ruby
#! /usr/bin/env ruby

require 'nokogiri'
require 'minitest/autorun'

class Test < MiniTest::Spec
  describe "Node#css" do
    it "should find a div using chained classes" do
      html = <<~HEREDOC
        <html>
          <body>
            <div class="foo"> one</div> 
            <div class="bar">two</div> 
            <div class="foo bar">three</div> 
      HEREDOC
      
      doc = Nokogiri::HTML::Document.parse(html)
      
      assert_equal 1, doc.css("div.foo.bar").length
      assert_equal "three", doc.at_css("div.foo.bar").text
    end
  end
end
```

If you haven't included a test, please provide whatever code you can, the inputs if any, along with the output that you're seeing. We need to reproduce what you're seeing to be able to help.


## Summary

To sum up the rules:

1. Report security vulnerabilities through [HackerOne][h1].
2. Mail [nokogiri-talk][nt] to ask for help or discuss whether something is a bug.
3. If you're absolutely sure you've got a bug AND you can reproduce it, then create a new bug report on [Github Issues][gi] with your repro code and description of expected behavior.

Thanks so much for reading this page! You're a good person, and Nokogiri loves you.

  [nt]: http://groups.google.com/group/nokogiri-talk
  [gi]: http://github.com/sparklemotion/nokogiri/issues
  [h1]: https://hackerone.com/nokogiri
