XRegExp = require 'xregexp'
_ = require 'lodash'

# REX/Javascript 1.0
# Robert D. Cameron "REX: XML Shallow Parsing with Regular Expressions",
# Technical Report TR 1998-17, School of Computing Science, Simon Fraser
# University, November, 1998.
# Copyright (c) 1998, Robert D. Cameron.
# The following code may be freely used and distributed provided that
# this copyright and citation notice remains intact and that modifications
# or additions are clearly identified.
TextSE = '[^<]+'
UntilHyphen = '[^-]*-'
Until2Hyphens = UntilHyphen + '([^-]' + UntilHyphen + ')*-'
CommentCE = Until2Hyphens + '>?'
UntilRSBs = '[^]]*]([^]]+])*]+'
CDATA_CE = UntilRSBs + '([^]>]' + UntilRSBs + ')*>'
S = '[ \\n\\t\\r]+'
NameStrt = '[A-Za-z_:]|[^\\x00-\\x7F]'
NameChar = '[A-Za-z0-9_:.-]|[^\\x00-\\x7F]'
Name = '(' + NameStrt + ')(' + NameChar + ')*'
QuoteSE = '"[^"]' + '*' + '"' + '|\'[^\']*\''
DT_IdentSE = S + Name + '(' + S + '(' + Name + '|' + QuoteSE + '))*'
MarkupDeclCE = '([^]"\'><]+|' + QuoteSE + ')*>'
S1 = '[\\n\\r\\t ]'
UntilQMs = '[^?]*\\?+'
PI_Tail = '\\?>|' + S1 + UntilQMs + '([^>?]' + UntilQMs + ')*>'
DT_ItemSE = '<(!(--' + Until2Hyphens + '>|[^-]' + MarkupDeclCE + ')|\\?' + Name + '(' + PI_Tail + '))|%' + Name + ';|' + S
DocTypeCE = DT_IdentSE + '(' + S + ')?(\\[(' + DT_ItemSE + ')*](' + S + ')?)?>?'
DeclCE = '--(' + CommentCE + ')?|\\[CDATA\\[(' + CDATA_CE + ')?|DOCTYPE(' + DocTypeCE + ')?'
PI_CE = Name + '(' + PI_Tail + ')?'
EndTagCE = Name + '(' + S + ')?>?'
AttValSE = '"[^<"]' + '*' + '"' + '|\'[^<\']*\''
ElemTagCE = Name + '(' + S + Name + '(' + S + ')?=(' + S + ')?(' + AttValSE + '))*(' + S + ')?/?>?'
MarkupSPE = '<(!(' + DeclCE + ')?|\\?(' + PI_CE + ')?|/(' + EndTagCE + ')?|(' + ElemTagCE + ')?)'
XML_SPE = TextSE + '|' + MarkupSPE

ShallowParse = (XMLdoc) ->
  XMLdoc.match new RegExp(XML_SPE, 'g')

# REX END - thank you Robert! Awesome...


# maybe this is a better way to think about it...
# don't hyperlink if parent stack contain any of
# these?
EXCLUDED_TAGS =
  a:
    a: true
  pre:
    img: true
    object: true
    big: true
    small: true
    sub: true
    sup: true
  button:
    input: true
    select: true
    textarea: true
    label: true
    button: true
    form: true
    fieldset: true
    iframe: true
    isindex: true
  label:
    label: true
  form:
    form: true


SELF_CLOSING_TAGS =
  area: true
  base: true
  br: true
  col: true
  embed: true
  hr: true
  img: true
  input: true
  link: true
  meta: true
  param: true
  source: true
  track: true
  wbr: true
  command: true
  keygen: true
  menuitem: true


ALLOWED_TAGS =
  br: true
  span: true
  bdo: true
  map: true
  object: true
  img: true
  tt: true
  i: true
  b: true
  big: true
  small: true 
  ins: true
  del: true
  script: true
  input: true
  select: true
  textarea: true
  label: true
  button: true
  em: true
  strong: true
  dfn: true
  code: true
  q: true
  samp: true
  kbd: true
  var: true
  cite: true
  abbr: true
  acronym: true
  sub: true
  sup: true


XMLParse   = (xml_doc) -> xml_doc.match new RegExp XML_SPE, "g"
expressionParse = (expression) -> expression.match XRegExp("[\\pL\\pN]+", "g")

makeTag = (tag, opts) ->
  if _.isEmpty(opts) then return '<' + tag + '>'
  opt_array = []
  _.each opts, (v, k) -> opt_array.push (k + '="' + opts[k] + '"')
  return '<' + tag + ' ' + opt_array.join(' ') + '>'


isOpen = (item) ->
  if !item
    return false
  if typeof item != 'string'
    return false
  if !item.match(/^</)
    return false
  if item.match(/^<\!/)
    return false
  if item.match(/^<\//)
    return false
  if item.match(/\/>$/)
    return false
  if item.match(/^<\?/)
    return false
  if item.match(/^</)
    return true
  return false



isClose = (item) ->
  if !item
    return false
  if typeof item != 'string'
    return false
  if !item.match(/^</)
    return false
  if item.match(/^<\!/)
    return false
  if item.match(/\/>$/)
    return false
  if item.match(/^<\//)
    return true
  return false
  false



isSelfClose = (item, selfclose) ->
  if isOpen(item) and selfclose[tagName(item)] then return true
  if !item
    return false
  if typeof item != 'string'
    return false
  if !item.match(/^</)
    return false
  if item.match(/^<\!/)
    return false
  if item.match(/^<\//)
    return false
  if item.match(/\/>$/) and item.match(/^</)
    return false
  false


isWord = (item) -> return item.match XRegExp("^[\\pL\\pN]+$")


isntWord = (item) -> return item.match XRegExp("^[^\\pL\\pN]+$")


tagName = (item) ->
  [ tag ] = item.match XRegExp("([\\pL\\pN]+)")
  return tag


close = (item) -> "</#{tagName(item)}>"



try_match = (xml, x_init, expression, tag, attributes, stack_parent, opts) ->
  
  # if this tag is excluded
  if opts.excluded
    forbidden = _.keys opts.excluded

    # so we take all forbidden tags...
    for forbidden_tag in forbidden

      # if any of these is in the parent stack, we can't match.
      for stacked_tag in stack_parent
        if tagName(stacked_tag) is forbidden_tag
          return null

  x = x_init

  t = 0

  ret_val = null
  result = []

  stack_pre  = null
  stack_post = null

  state = 'ROUTE'

  FSM =

    OPENTAG: ->
      item = xml[x]
      if opts.allowed[tagName(item)]
        stack_post or= []
        stack_post.push item
        result.push item
        x++
        state = 'ROUTE'
      else
        state = 'FAIL'

    CLOSETAG: ->
      item = xml[x]
      if opts.allowed[tagName(item)]
        if stack_post
          stack_post.pop()
        else
          stack_pre or= []
          stack_pre.push item
        result.push item
        x++
        state = 'ROUTE'
      else
        state = 'FAIL'

    OTHER: ->
      item = xml[x]
      result.push item
      x++
      state = 'ROUTE'

    WORD: ->
      item = xml[x]
      if item.toLowerCase() is expression[t].toLowerCase()
        result.push item
        x++
        t++
        state = 'ROUTE'
      else
        state = 'FAIL'

    SUCCESS: ->
      xml[x_init]
      offset = x - x_init

      stack_pre or= []
      stack_post or= []

      if stack_pre.length
        outer_head = stack_pre.join ('')
      else
        outer_head = ''

      opentag = makeTag(tag, attributes)

      if stack_pre.length
        inner_head = stack_parent.slice(- stack_pre.length).join ''
      else
        inner_head = ''
      inner_body = result.join('')

      if stack_post.length
        inner_tail = stack_post.reverse().map((item) -> close(item)).join('')
      else
        inner_tail = ''

      closetag = '</' + tag + '>'

      if stack_post.length
        outer_tail = stack_post.join('')
      else
        outer_tail = ''


      result = outer_head + opentag + inner_head + inner_body + inner_tail + closetag + outer_tail

      # modify the xml array with the new element
      xml.splice x_init, offset, result
      ret_val = x + 1
      state = 'STOP'

    FAIL: ->
      ret_val = null
      state = 'STOP'

    ROUTE: ->
      if t is expression.length
        state = 'SUCCESS'
        return

      if xml.length is 0
        state = 'FAIL'
        return

      if isSelfClose(xml[x], opts.selfclose)
        state = 'OTHER'
        return

      if isOpen(xml[x])
        state = 'OPENTAG'
        return

      if isClose(xml[x])
        item = xml[x]
        if opts.allowed[tagName(item)]
          state = 'CLOSETAG'
          return
        else
          state = 'FAIL'
          return

      if isWord(xml[x])
        state = 'WORD'
        return

      if isntWord(xml[x])
        state = 'OTHER'
        return

      console.error "Unexpected state. Please file a bug report!"
      state = 'FAIL'

  # when we're done, join all the XML bits to compute the result
  while state isnt 'STOP'
    if FSM[state]
      FSM[state]()
    else
      console.log state, " not implemented..."
      process.exit 0
  return ret_val



_linkify = (xml, items, opts) ->
  x = 0 # xml index
  i = 0 # items index
  e = 0 # item expression index

  stack = []
  state = 'ROUTE'
  FSM =

    TRY_MATCH: ->
      item = items[i]
      if item
        attributes = item.attributes or {}
        _opts =
          selfclose: item.selfclose or opts.selfclose
          allowed: item.allowed or opts.allowed

        if item.excluded
          _opts.excluded = item.excluded or {}
        else
          _opts.excluded = opts.excluded[item.tag] or {}

        result = try_match xml, x, expressionParse(item.expression), item.tag, item.attributes, stack, _opts
        if result
          x = result
          i = 0
          state = 'ROUTE'
        else
          i++
          state = 'TRY_MATCH'
      else
        i = 0
        x++
        state = 'ROUTE'


    WORD: ->
      if items[i]
        state = 'TRY_MATCH'
      else
        x++
        state = 'ROUTE'

    NOTWORD: ->
      x++
      state = 'ROUTE'

    SELF_CLOSE: ->
      state = 'ROUTE'
      x++

    OPEN: ->
      stack.push xml[x]
      state = 'ROUTE'
      x++

    CLOSE: ->
      stack.pop()
      state = 'ROUTE'
      x++

    ROUTE: ->

      if x >= xml.length
        state = 'STOP'
        return

      if isSelfClose(xml[x], opts.selfclose)
        state = 'SELF_CLOSE'
        return

      if isOpen(xml[x])
        state = 'OPEN'
        return

      if isClose(xml[x])
        state = 'CLOSE'
        return

      if isWord(xml[x])
        state = 'WORD'
        return

      if isntWord(xml[x])
        state = 'NOTWORD'
        return

      # should never happen, defensive
      x++
      return


  # when we're done, join all the XML bits to compute the result
  while state isnt 'STOP'
    prev_state = state
    if FSM[state]
      FSM[state]()
    else
      console.log state, " not implemented..."
      process.exit 0

  return xml.join ''


tokenize_text = (xml, selfclose) ->
  result = []
  _.each xml, (item) ->
    if isSelfClose(item, selfclose) or isOpen(item) or isClose(item)
      result.push item
    else
      result.push item.match(XRegExp("[\\pL\\pN]+|[^\\pL\\pN]+", "g"))...
  return result


linkify = (xml, items, opts) ->
  opts or= {}
  opts.allowed or= ALLOWED_TAGS
  opts.selfclose or= SELF_CLOSING_TAGS
  opts.excluded or= EXCLUDED_TAGS

  xml = ShallowParse(xml)
  xml = tokenize_text xml, opts.selfclose
  return _linkify xml, items, opts


module.exports             = linkify
module.exports.allowed     = ALLOWED_TAGS
module.exports.selfclosing = SELF_CLOSING_TAGS
module.exports.excluded    = EXCLUDED_TAGS