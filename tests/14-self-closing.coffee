assert = require 'assert'
tag = require '../index'

describe 'self-closing tags', ->

  it 'should not match across self-closing br tags', ->
    xml = "<p>hello<br/>world</p>"
    items = [
      { expression: "hello world", tag: 'a', attributes: { href: "http://example.com" } }
    ]
    result = tag(xml, items)
    assert !result.match('<a '), "should not match across br, got: #{result}"

  it 'should handle hr tags between paragraphs', ->
    xml = "<p>hello</p><hr/><p>world</p>"
    items = [
      { expression: "hello", tag: 'b' }
    ]
    result = tag(xml, items)
    assert result.match('<b>hello</b>'), "got: #{result}"
    assert result.match('<hr/>'), "hr should be preserved, got: #{result}"

  it 'should handle img within expression', ->
    xml = "<p>click<img src='icon.png'/>here</p>"
    items = [
      { expression: "click here", tag: 'a', attributes: { href: "http://example.com" } }
    ]
    result = tag(xml, items)
    assert result.match("click"), "got: #{result}"
    assert result.match("here"), "got: #{result}"
