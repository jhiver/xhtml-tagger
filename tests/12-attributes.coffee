assert = require 'assert'
tag = require '../index'

describe 'tag attributes', ->

  it 'should create tag with no attributes', ->
    xml = "hello"
    items = [
      { expression: "hello", tag: 'b' }
    ]
    result = tag(xml, items)
    assert.strictEqual result, "<b>hello</b>"

  it 'should create tag with single attribute', ->
    xml = "hello"
    items = [
      { expression: "hello", tag: 'a', attributes: { href: "http://example.com" } }
    ]
    result = tag(xml, items)
    assert.strictEqual result, '<a href="http://example.com">hello</a>'

  it 'should create tag with multiple attributes', ->
    xml = "hello"
    items = [
      { expression: "hello", tag: 'a', attributes: { href: "http://example.com", class: "link" } }
    ]
    result = tag(xml, items)
    assert result.match('href="http://example.com"'), "got: #{result}"
    assert result.match('class="link"'), "got: #{result}"
    assert result.match(/^<a /), "got: #{result}"
    assert result.match(/>hello<\/a>$/), "got: #{result}"
