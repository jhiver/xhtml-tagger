tag = require '../index'


describe 'allowed', ->

  xml = """<p>testing! hello <foo>world</foo>. this is a test.</p>"""

  it 'should not tag if has not been allowed', (done) ->
    items = [
      { expression: "hello world", tag: 'a', attributes: { href: "http://www.example.com" } }
    ]

    if tag(xml, items).match '<p>testing! hello <foo>world</foo>. this is a test.</p>'
      done()
    else
      done("unexpected result")


  it 'should tag if has been allowed', (done) ->
    items = [
      { expression: "hello world", tag: 'a', attributes: { href: "http://www.example.com" }, allowed: { foo: true } }
    ]

    if tag(xml, items).match '<a href="http://www.example.com">hello <foo>world</foo></a>'
      done()
    else
      done("unexpected result")
      