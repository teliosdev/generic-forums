((export)->
  class export.BbCodeParser
    constructor: (@text)->

    toHtml: ->
      @_getNodes()
      @_parseTags()
      @_createHTML()

    _getNodes: ->
      @text.eachChar (c)->


  class Node
    constrcutor: (@type)->


  String.prototype.eachChar = (callback)->
    for i in 0..@length
      callback(@charAt(i))

)
