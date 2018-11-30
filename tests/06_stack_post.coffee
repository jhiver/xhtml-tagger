tag = require '../index'


describe 'stack_post', ->

  xml = """<p>this is a <em> test and we should</em> be doing great"""
  items = [
    { expression: "a test", tag: 'i' }
  ]

  result = tag(xml, items)

  it 'should close and reopen closing tags', (done) ->
    if tag(xml, items).match 'is <i>a <em> test</em></i><em> and'
      done()
    else
      done("unexpected result")