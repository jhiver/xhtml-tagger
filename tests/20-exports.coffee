assert = require 'assert'
tag = require '../index'

describe 'module exports', ->

  it 'should export the linkify function as default', ->
    assert.strictEqual typeof tag, 'function'

  it 'should export allowed tags', ->
    assert tag.allowed
    assert.strictEqual tag.allowed.br, true
    assert.strictEqual tag.allowed.em, true
    assert.strictEqual tag.allowed.strong, true
    assert.strictEqual tag.allowed.span, true
    assert.strictEqual tag.allowed.i, true
    assert.strictEqual tag.allowed.b, true
    assert.strictEqual tag.allowed.img, true

  it 'should export self-closing tags', ->
    assert tag.selfclosing
    assert.strictEqual tag.selfclosing.br, true
    assert.strictEqual tag.selfclosing.hr, true
    assert.strictEqual tag.selfclosing.img, true
    assert.strictEqual tag.selfclosing.input, true
    assert.strictEqual tag.selfclosing.meta, true

  it 'should export excluded tags', ->
    assert tag.excluded
    assert tag.excluded.a
    assert.strictEqual tag.excluded.a.a, true
    assert tag.excluded.pre
    assert tag.excluded.form
    assert.strictEqual tag.excluded.form.form, true
    assert tag.excluded.label
    assert.strictEqual tag.excluded.label.label, true
    assert tag.excluded.button
