assert = require 'assert'
tag = require '../index'

describe 'custom options', ->

  it 'should respect custom selfclose option', ->
    xml = "<p>hello <mytag /> world</p>"
    items = [
      { expression: "hello world", tag: 'b' }
    ]
    result = tag(xml, items, { selfclose: { mytag: true } })
    assert result.match('hello'), "got: #{result}"
    assert result.match('world'), "got: #{result}"

  it 'should respect custom allowed at item level', ->
    xml = "<p>hello <custom>world</custom></p>"
    items = [
      { expression: "hello world", tag: 'b', allowed: { custom: true } }
    ]
    result = tag(xml, items)
    assert result.match('<b>hello <custom>world</custom></b>'), "got: #{result}"

  it 'should fail match when tag not in allowed list', ->
    xml = "<p>hello <custom>world</custom></p>"
    items = [
      { expression: "hello world", tag: 'b' }
    ]
    result = tag(xml, items)
    assert !result.match('<b>hello <custom>world</custom></b>'), "custom tag should block match, got: #{result}"
