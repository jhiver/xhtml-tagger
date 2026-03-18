assert = require 'assert'
tag = require '../index'

describe 'unicode support', ->

  it 'should match unicode words', ->
    xml = "<p>café latte</p>"
    items = [
      { expression: "café latte", tag: 'b' }
    ]
    result = tag(xml, items)
    assert result.match('<b>café latte</b>'), "got: #{result}"

  it 'should match accented characters', ->
    xml = "<p>résumé disponible</p>"
    items = [
      { expression: "résumé", tag: 'i' }
    ]
    result = tag(xml, items)
    assert result.match('<i>résumé</i>'), "got: #{result}"

  it 'should match chinese characters', ->
    xml = "<p>你好世界</p>"
    items = [
      { expression: "你好世界", tag: 'b' }
    ]
    result = tag(xml, items)
    assert result.match('<b>你好世界</b>'), "got: #{result}"

  it 'should match cyrillic text', ->
    xml = "<p>привет мир</p>"
    items = [
      { expression: "привет мир", tag: 'b' }
    ]
    result = tag(xml, items)
    assert result.match('<b>привет мир</b>'), "got: #{result}"
