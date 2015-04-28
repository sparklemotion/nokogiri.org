# Getting Help and Reporting Issues

## Halp!

So you're having a great time slicing and dicing your XML with
Nokogiri, and suddenly something happens that you don't quite
understand. O NOES, the good times are over.

What do you do?

## Step 1: Mail [nokogiri-talk][nt], grasshopper.

The best thing to do if you've got a question, or are unsure how to
diagnose a possible issue, want to complain or just ask for advice on
how to solve a problem, is to email the [nokogiri-talk][nt]
list.

You should also probably **subscribe** to the list. You can either use
the [web interface][nt]; or if you're like RMS and hate to use
javascripty things like Google's web interface, you can subscribe to
the list by sending an empty email to this address:

```
nokogiri-talk+subscribe@googlegroups.com
```

The [nokogiri-talk][nt] list has hundreds of subscribers who are all using
nokogiri and who are happy to lend a hand, offer advice, and bail you
out of tricky situations.

In addition, other people may have the same issue or complaint, and so
preserving the question and responses in the mailing list archive is a
gift to future Nokogiri users __just like you__!

### But I want to report a bug!

Step 1 should still be your first step. Mail [nokogiri-talk][nt] first, and
verify that this is really a bug. If there's going to be a
bug-or-not-bug conversation, it's better that it happens transparently
on the list than somewhere hidden, like off-list emails or Github
Issues.

### But I want to verify my issue with the maintainer(s) before I spam the list!

Valid questions and complaints aren't spam! :)

The maintainers vastly prefer nokogiri-related emails to be sent to
[nokogiri-talk][nt] than to their personal accounts. Again, an archive
of discussion has a lot of value. Also, the maintainers may not
respond as quickly as some of the subscribers on the mailing list.

### But I emailed the list and my question hasn't been posted yet!

The [nokogiri-talk][nt] google group is set for first-post moderation,
meaning that the first time you email the list, your post will be held
for review. Once your post is accepted, there won't be any delay on
future emails.

There's _never_ more than a few hour delay on moderation. Thanks for
your patience.

## Step 2: "You got so many [Issues][gi] you need a magazine rack."

So you say you've got a bug. That's great! We always want to increase
the yummy candy-coated goodness of Nokogiri, so if you've got a bug,
we want to hear about it.

We track boogs on [Github Issues][gi], which notifies the maintainers
every time a new ticket is created.

### What's In a Bug Report?

Whoa, do we have strong opinions on this topic. The two most important
things that a bug report needs to contain are:

1. Example code that reproduces the __observed__ behavior.
2. An explanation of what the __expected__ behavior is.

### That's it?

Yes, that's it.

If you're a solid Rubyist, you should be able to provide a **short,
self-contained script** that reproduces and demonstrates the
behavior. [Here's a great example.][issue-with-sample]

If you want to go above-and-beyond, impress the judge from the Czech
Republic, and prove to everyone you went to high school with that
you're better than them, you could even write a **failing unit test**
that meets both criteria in one fell swoop. [Like this
guy.][issue-with-test]

## Summary

To sum up the rules:

1. Mail [nokogiri-talk][nt].
2. No, really, mail [nokogiri-talk][nt].
3. If you're really, absolutely, positively sure you've got a bug AND you can reproduce it, then mail [nokogiri-talk][nt].
4. If you've confirmed it's a bug on [nokogiri-talk][nt], then create a new bug report on [Github Issues][gi] with your repro code and description of expected behavior.

Thanks so much for reading this page! You're a good person, and Nokogiri loves you.

  [nt]: http://groups.google.com/group/nokogiri-talk
  [gi]: http://github.com/sparklemotion/nokogiri/issues
  [issue-with-sample]: http://github.com/sparklemotion/nokogiri/issues/158
  [issue-with-test]: https://github.com/sparklemotion/nokogiri/issues/695
