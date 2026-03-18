assert = require 'assert'
tag = require '../index'

describe 'HTML entities and special content', ->

  it 'should handle HTML entities in text', ->
    xml = "<p>let&#39;s try hello world</p>"
    items = [
      { expression: "hello world", tag: 'b' }
    ]
    result = tag(xml, items)
    assert result.match('<b>hello world</b>'), "got: #{result}"

  it 'should handle HTML comments', ->
    xml = "<p><!-- comment -->hello world</p>"
    items = [
      { expression: "hello world", tag: 'b' }
    ]
    result = tag(xml, items)
    assert result.match('<b>hello world</b>'), "got: #{result}"
    assert result.match('<!-- comment -->'), "comment preserved, got: #{result}"

  it 'should handle nbsp entities', ->
    xml = "<p>hello&nbsp;world and more</p>"
    items = [
      { expression: "and more", tag: 'b' }
    ]
    result = tag(xml, items)
    assert result.match('<b>and more</b>'), "got: #{result}"
