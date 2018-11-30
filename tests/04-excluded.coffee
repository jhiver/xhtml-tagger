tag = require '../index'


describe 'excluded', ->

  xml = """<a href="http://www.example.com">testing! hello, world. this is a test.</a>"""
  items = [
    expression: "hello world", tag: 'a', href: "http://www.example.com"
  ]

  it 'should not tag excluded', (done) ->
    if tag(xml, items).match '<a href="http://www.example.com">testing! hello, world. this is a test.</a>'
      done()
    else
      done("unexpected result")