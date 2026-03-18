assert = require 'assert'
tag = require '../index'

describe 'case insensitive matching', ->

  it 'should match expression regardless of case', ->
    xml = "<p>Hello World</p>"
    items = [
      { expression: "hello world", tag: 'a', attributes: { href: "http://example.com" } }
    ]
    result = tag(xml, items)
    assert result.match('<a href="http://example.com">Hello World</a>'), "got: #{result}"

  it 'should match UPPERCASE expression against lowercase text', ->
    xml = "<p>hello world</p>"
    items = [
      { expression: "HELLO WORLD", tag: 'a', attributes: { href: "http://example.com" } }
    ]
    result = tag(xml, items)
    assert result.match('<a href="http://example.com">hello world</a>'), "got: #{result}"

  it 'should match MiXeD case expression', ->
    xml = "<p>HELLO world</p>"
    items = [
      { expression: "hElLo WoRlD", tag: 'a', attributes: { href: "http://example.com" } }
    ]
    result = tag(xml, items)
    assert result.match('<a href="http://example.com">HELLO world</a>'), "got: #{result}"
