tag = require '../index'


describe 'simple', ->

  xml = "<p>hello, world. this is a test.</p>"
  items = [
    expression: "hello world", tag: 'a', attributes: { href: "http://www.example.com" }
  ]

  it 'should pass', (done) ->
    if tag(xml, items).match '<a href="http://www.example.com">hello, world</a>.'
      done()
    else
      done("unexpected result")