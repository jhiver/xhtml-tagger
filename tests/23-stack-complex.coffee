assert = require 'assert'
tag = require '../index'

describe 'complex stack scenarios', ->

  it 'should handle tag closing before and opening during match', ->
    xml = "<p><em>hello</em> <strong>world</strong></p>"
    items = [
      { expression: "hello world", tag: 'a', attributes: { href: "http://example.com" } }
    ]
    result = tag(xml, items)
    assert result.match('hello'), "got: #{result}"
    assert result.match('world'), "got: #{result}"
    assert result.match('</a>'), "should have closing tag, got: #{result}"

  it 'should handle em wrapping entire expression', ->
    xml = "<p>test <em>hello world</em> done</p>"
    items = [
      { expression: "hello world", tag: 'b' }
    ]
    result = tag(xml, items)
    assert result.match('<b>'), "should tag, got: #{result}"
    assert result.match('hello'), "got: #{result}"
    assert result.match('world'), "got: #{result}"

  it 'should handle strong tag starting before expression', ->
    xml = "<p><strong>before hello</strong> world after</p>"
    items = [
      { expression: "hello world", tag: 'i' }
    ]
    result = tag(xml, items)
    assert result.match('hello'), "got: #{result}"
    assert result.match('world'), "got: #{result}"
    assert result.match('</i>'), "got: #{result}"

  it 'should handle multiple tags starting during expression', ->
    xml = "<p>hello <em><strong>world</strong></em></p>"
    items = [
      { expression: "hello world", tag: 'a', attributes: { href: "http://example.com" } }
    ]
    result = tag(xml, items)
    assert result.match('hello'), "got: #{result}"
    assert result.match('world'), "got: #{result}"
    assert result.match('</a>'), "got: #{result}"
