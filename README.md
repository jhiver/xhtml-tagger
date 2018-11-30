# xhtml-tagger
A javascript library to automagically tag XHTML content.

Actually the parsing is pretty relaxed, so it should also work with HTML 5 and HTML fragments.


# usage:

Say you have some XHTML content like so:

    let xhtml = `
    <html>
      <body>
        <h2>Welcome to XHTML Tagger!</h2>
        <p>XHTML Tagger is a NodeJS library which will automatically
        tag your XHTML content based on a list of expressions.</p>
      </body>
    <html>
    `

And you want to tag the following list of expressions:

    let links = [
      { "expression": "XHTML Tagger", "tag": "a", "attributes": { "href": "https://github.com/jhiver/xhtml-tagger" } },
      { "expression": "XHTML" , "tag": "a", "attributes": { "href": "https://en.wikipedia.org/wiki/XHTML" } },
      { "expression": "list of expressions", "tag": "em" },
      { "expression": "https://nodejs.org/en/", "tag": "a", "attributes": {
          "href": "https://en.wikipedia.org/wiki/XHTML",
          "target": "_new" }
      }
    ]


You can do:

    let tagger = require('xhtml-tagger')
    console.log(tagger.tag(xhtml, links))


And it will output:

    <html>
      <body>
        <h2>Welcome to <a href="https://github.com/jhiver/xhtml-tagger">XHTML Tagger</a>!</h2>
        <p>
          <a href="https://github.com/jhiver/xhtml-tagger">XHTML Tagger</a> is a <a href="https://nodejs.org/en/" target="_new">NodeJS</a> library which will automatically
          tag your <a href="https://en.wikipedia.org/wiki/XHTML">XHTML</a> content based on <b>a </b><em><b>list</b> of expressions</em>.
        </p>
      </body>
    <html>


# Works out overlapping tags

Consider this XHTML fragment:

    Hello <b>beautiful world</b>

And these links:

    let links = [
      { "expression": "hello beautiful", "tag": "em" }
    ]

XHTML Tagger does not produce, the following, as it would be invalid (x)HTML.

    <em>Hello <b>beautiful</em> world</b>

Instead it properly closes and reopens tags as required, e.g.
  
    <em>Hello </em><b><em>beautiful</em> world</b>

  
# Matches in order

XHTML Tagger will try to tag the expressions in the same order that you supply it with.

Once it's tagged something using a given expression, it won't try to tag it any further, e.g.
doing:

    let links = [
      { "expression": "XHTML Tagger", "tag": "a", { "href": "https://github.com/jhiver/xhtml-tagger" } },
      { "expression": "XHTML Tagger", "tag": "em" }
    ]

Will only result in "XHTML Tagger" getting tagged once.

Make sure you sort your expressions array in the order you want them to be matched, longest
expression first would seem like a most sensible choice, but it's totally left up to you.


# Allowed tags

Not all tags can be embedded within hyperlinks. For example, you wouldn't link a iframe.

XHTML Tagger restricts the tags which can be embedded to a sensible set of defaults which
is exported in `tagger.allowed`. Say you have the following fragment which you want to hyperlink:

    This is a <foo>custom</foo> thing.

You would need to set `tagger.allowed.foo = true` in order for it to work.

Please note that the allowed tag only applies to tags which may be WITHIN the tagged expression.

You can also specify the list of allowed tags as an option when tagging:

    // if our expression is "hello beautiful world"
    // this would match hello <b>beautiful</b> world
    // but not hello beautiful<br />world
    tagger.tag(xhtml, links, allowed: {
      "b": true,
      "em": true
      "i": true
    })


You can even be more specific and specify the list of allowed tags as a link option:

    let links = [
      { "expression": "XHTML Tagger", "tag": "em", "allowed": { "b": true, "em": true, "i", true } }
    ]


Expression options override the tag options, which itself overrides the defaults.


# Excluded tags

It may be impossible to tag an expression if it is within certain parent tags.

For example, according to the XHTML specification, button must not contain the input, select, textarea,
label, button, form, fieldset, iframe or isindex elements.

XHTML Tagger exports a list of disallowed tags in `tagger.excluded`. So if you wanted to be able
to tag a an iframe within a button, you could do `delete tagger.excluded.button.iframe`

Say on top of the existing defaults, you don't want hyperlink things which are children of `<strong>`

You would do:

    if(!tagger.excluded.strong) tagger.excluded.strong = {}
    tagger.excluded.strong.a = true


You can also specify the list of excluded tags as an option when tagging:

    // don't tag if the expression is a child of <b> element
    tagger.tag(xhtml, links, excluded: {
      "b": true,
    })


You can even be more specific and specify the list of excluded tags as a link option:

    // don't tag this expression if it's a child of <b> element
    let ems = [
      { "expression": "XHTML Tagger", "tag": "em", "excluded": { "b": true }
    ]


Again, expression options override the tag options, which itself overrides the defaults.



# Self closing tags

This is normally un-necessary for XHTML, but if you're using HTML 5, some tags should be
considered self closing. There is a default dictionary which is exported with `tagger.selfclosing`.

Once again, this can be specified globally:

    tagger.selfclosing.a = true

When calling the function:

    tagger.tag(xhtml, links, selfclosing: {
      "br": true,
    })

Or at the expression level:

    let ems = [
      { "expression": "XHTML Tagger", "tag": "em", "selfclosing": { "b": true }
    ]


# EXPORTS

- tagger()
- tagger.allowed
- tagger.selfclosing


# BUGS

If you find any, please drop me an email - jhiver (at) gmail (dot) com.
Patches & pull requests are always welcome of course!


# ALSO

This module free software and is distributed under the same license as node.js
itself (MIT license)

Copyright (C) 2018 - Jean-Michel Hiver

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.