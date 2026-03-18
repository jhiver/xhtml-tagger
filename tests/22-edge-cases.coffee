assert = require 'assert'
tag = require '../index'

describe 'edge cases', ->

  it 'should handle single word expression', ->
    xml = "<p>hello</p>"
    items = [
      { expression: "hello", tag: 'b' }
    ]
    result = tag(xml, items)
    assert result.match('<b>hello</b>'), "got: #{result}"

  it 'should handle expression at start of text', ->
    xml = "hello world then more"
    items = [
      { expression: "hello world", tag: 'b' }
    ]
    result = tag(xml, items)
    assert result.match('<b>hello world</b>'), "got: #{result}"

  it 'should handle expression at end of text', ->
    xml = "some text then hello world"
    items = [
      { expression: "hello world", tag: 'b' }
    ]
    result = tag(xml, items)
    assert result.match('<b>hello world</b>'), "got: #{result}"

  it 'should handle three word expression', ->
    xml = "<p>one two three</p>"
    items = [
      { expression: "one two three", tag: 'b' }
    ]
    result = tag(xml, items)
    assert result.match('<b>one two three</b>'), "got: #{result}"

  it 'should handle long expression', ->
    xml = "<p>the quick brown fox jumps over the lazy dog</p>"
    items = [
      { expression: "quick brown fox", tag: 'i' }
    ]
    result = tag(xml, items)
    assert result.match('<i>quick brown fox</i>'), "got: #{result}"

  it 'should not match partial words', ->
    xml = "<p>helloworld</p>"
    items = [
      { expression: "hello", tag: 'b' }
    ]
    result = tag(xml, items)
    assert !result.match('<b>hello</b>'), "should not match partial word, got: #{result}"

  it 'should handle empty items array', ->
    xml = "<p>hello world</p>"
    result = tag(xml, [])
    assert.strictEqual result, "<p>hello world</p>"

  it 'should tag different types of tags', ->
    xml = "hello"
    for tagName in ['b', 'i', 'em', 'strong', 'span']
      items = [
        { expression: "hello", tag: tagName }
      ]
      result = tag(xml, items)
      assert.strictEqual result, "<#{tagName}>hello</#{tagName}>"
