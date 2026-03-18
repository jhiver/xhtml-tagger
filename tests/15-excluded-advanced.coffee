assert = require 'assert'
tag = require '../index'

describe 'excluded tags advanced', ->

  it 'should not nest a inside a (default excluded)', ->
    xml = '<a href="http://existing.com">hello world</a>'
    items = [
      { expression: "hello world", tag: 'a', attributes: { href: "http://new.com" } }
    ]
    result = tag(xml, items)
    assert !result.match('http://new.com'), "should not create nested a tag, got: #{result}"
    assert result.match('http://existing.com'), "original link preserved, got: #{result}"

  it 'should allow tagging with non-a tag inside a', ->
    xml = '<a href="http://existing.com">hello world</a>'
    items = [
      { expression: "hello world", tag: 'b' }
    ]
    result = tag(xml, items)
    assert result.match('<b>hello world</b>'), "should allow b inside a, got: #{result}"

  it 'should respect custom excluded tags on item', ->
    xml = '<div>hello world</div>'
    items = [
      { expression: "hello world", tag: 'b', excluded: { div: true } }
    ]
    result = tag(xml, items)
    assert !result.match('<b>'), "should not tag when custom excluded, got: #{result}"

  it 'should not nest form inside form (default excluded)', ->
    xml = '<form><p>submit form</p></form>'
    items = [
      { expression: "submit form", tag: 'form' }
    ]
    result = tag(xml, items)
    formTags = result.match(/<form>/g) or []
    assert.strictEqual formTags.length, 1, "should not nest form, got: #{result}"

  it 'should not nest label inside label (default excluded)', ->
    xml = '<label>click label</label>'
    items = [
      { expression: "click label", tag: 'label' }
    ]
    result = tag(xml, items)
    labelTags = result.match(/<label>/g) or []
    assert.strictEqual labelTags.length, 1, "should not nest label, got: #{result}"
