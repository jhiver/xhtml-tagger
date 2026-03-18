assert = require 'assert'
tag = require '../index'

describe 'multiple expressions', ->

  it 'should match multiple different expressions', ->
    xml = "<p>hello world and foo bar</p>"
    items = [
      { expression: "hello world", tag: 'a', attributes: { href: "http://hello.com" } }
      { expression: "foo bar", tag: 'a', attributes: { href: "http://foo.com" } }
    ]
    result = tag(xml, items)
    assert result.match('<a href="http://hello.com">hello world</a>'), "got: #{result}"
    assert result.match('<a href="http://foo.com">foo bar</a>'), "got: #{result}"

  it 'should match all occurrences when expression appears twice', ->
    xml = "<p>hello and hello</p>"
    items = [
      { expression: "hello", tag: 'b' }
    ]
    result = tag(xml, items)
    matches = result.match(/<b>hello<\/b>/g)
    assert.strictEqual matches.length, 2, "should match both, got: #{result}"

  it 'should apply first matching expression when overlapping', ->
    xml = "<p>hello world</p>"
    items = [
      { expression: "hello", tag: 'b' }
      { expression: "hello world", tag: 'i' }
    ]
    result = tag(xml, items)
    assert result.match('<b>hello</b>'), "first item should win, got: #{result}"
    assert !result.match('<i>'), "second item should not match, got: #{result}"
