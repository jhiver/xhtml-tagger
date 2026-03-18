assert = require 'assert'
tag = require '../index'

describe 'nested HTML structures', ->

  it 'should handle deeply nested tags', ->
    xml = "<div><p><span>hello world</span></p></div>"
    items = [
      { expression: "hello world", tag: 'b' }
    ]
    result = tag(xml, items)
    assert result.match('<b>hello world</b>'), "got: #{result}"

  it 'should handle expression spanning inline tags', ->
    xml = "<p>hello <em>world</em></p>"
    items = [
      { expression: "hello world", tag: 'b' }
    ]
    result = tag(xml, items)
    assert result.match('<b>hello <em>world</em></b>'), "got: #{result}"

  it 'should handle multiple inline tags in expression', ->
    xml = "<p><em>hello</em> <strong>world</strong></p>"
    items = [
      { expression: "hello world", tag: 'a', attributes: { href: "http://example.com" } }
    ]
    result = tag(xml, items)
    assert result.match('hello'), "got: #{result}"
    assert result.match('world'), "got: #{result}"

  it 'should tag inside a paragraph among other paragraphs', ->
    xml = "<div><p>first paragraph</p><p>hello world</p><p>last paragraph</p></div>"
    items = [
      { expression: "hello world", tag: 'b' }
    ]
    result = tag(xml, items)
    assert result.match('<b>hello world</b>'), "got: #{result}"
    assert result.match('<p>first paragraph</p>'), "first paragraph unchanged, got: #{result}"
    assert result.match('<p>last paragraph</p>'), "last paragraph unchanged, got: #{result}"
