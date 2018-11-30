tag = require '../index'

describe 'simple match', ->

  xml = "hello"
  items = [
    expression: "hello", tag: 'a', attributes: { href: "http://www.example.com" }
  ]

  it 'should pass', (done) ->
    if tag(xml, items).match '<a href="http://www.example.com">hello</a>'
      done()
    else
      done("unexpected result")