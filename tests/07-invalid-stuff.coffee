tag = require '../index'


describe 'invalid_stuff', ->

  xml = """
  <div class="component markdown" id="bienvenue" style="border: 1px dotted black">
    <div style="position:absolute; right:5px; padding-right:1.5em">
      <a href="./bienvenue/">
        <i class="fa fa-cog fa-2x" style="text-shadow: 3px 3px #272634"></i>
      </a>
    </div>
    <h2>Bienvenue</h2>
    <hr />

  <p><strong>Advertisement :)</strong></p>

  <ul><li><strong><a href="https://nodeca.github.io/pica/demo/">pica</a></strong> - high quality and fast image
  resize in browser.</li><li><strong><a href="https://github.com/nodeca/babelfish/">babelfish</a></strong> - developer friendly
  i18n with plurals support and easy syntax.</li></ul>

  <p>Let&#39;s try to link some news.</p>

  <p>You will like those projects!</p>

  <hr/>
  </div>
  """
  items = [
    { expression: "news", tag: 'i' }
  ]

  it 'should close and reopen closing tags', (done) ->
    if tag(xml, items).match '<i>news</i>'
      done()
    else
      done("unexpected result")