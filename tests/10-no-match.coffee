assert = require 'assert'
tag = require '../index'

describe 'no match scenarios', ->

  it 'should return unchanged text when no items provided', ->
    xml = "<p>hello world</p>"
    result = tag(xml, [])
    assert.strictEqual result, "<p>hello world</p>"

  it 'should return unchanged text when expression not found', ->
    xml = "<p>hello world</p>"
    items = [
      { expression: "goodbye", tag: 'a', attributes: { href: "http://example.com" } }
    ]
    result = tag(xml, items)
    assert.strictEqual result, "<p>hello world</p>"

  it 'should return plain text unchanged when no items', ->
    xml = "just some text"
    result = tag(xml, [])
    assert.strictEqual result, "just some text"
