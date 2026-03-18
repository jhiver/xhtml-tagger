assert = require 'assert'
tag = require '../index'

describe 'punctuation handling', ->

  it 'should match across commas', ->
    xml = "<p>hello, world</p>"
    items = [
      { expression: "hello world", tag: 'b' }
    ]
    result = tag(xml, items)
    assert result.match('<b>hello, world</b>'), "got: #{result}"

  it 'should match across semicolons', ->
    xml = "<p>hello; world</p>"
    items = [
      { expression: "hello world", tag: 'b' }
    ]
    result = tag(xml, items)
    assert result.match('<b>hello; world</b>'), "got: #{result}"

  it 'should match across multiple spaces', ->
    xml = "<p>hello   world</p>"
    items = [
      { expression: "hello world", tag: 'b' }
    ]
    result = tag(xml, items)
    assert result.match('<b>hello   world</b>'), "got: #{result}"

  it 'should match with dash between words', ->
    xml = "<p>hello-world</p>"
    items = [
      { expression: "hello world", tag: 'b' }
    ]
    result = tag(xml, items)
    assert result.match('<b>hello-world</b>'), "got: #{result}"

  it 'should preserve surrounding punctuation', ->
    xml = "<p>(hello world)!</p>"
    items = [
      { expression: "hello world", tag: 'b' }
    ]
    result = tag(xml, items)
    assert result.indexOf('(<b>hello world</b>)!') >= 0, "got: #{result}"
