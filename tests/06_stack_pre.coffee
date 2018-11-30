tag = require '../index'


describe 'stack_pre', ->

  xml = """<p>this <em>is a </em> test and we should be doing great"""
  items = [
    { expression: "a test", tag: 'i' }
  ]

  result = tag(xml, items)

  it 'should close and reopen closing tags', (done) ->
    if tag(xml, items).match '<p>this <em>is </em><i><em>a </em> test</i> and'
      done()
    else
      done("unexpected result")