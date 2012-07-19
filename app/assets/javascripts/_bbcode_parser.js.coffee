((exports)->

  # Instead of the node hirearchy in rbcode, this does a linear list
  # of the things in the string.

  class exports.BBCodeParser
    constructor: (@string)->

    addNode: (type)=>
      @nodeList.push new Node(type)

    currentNode: =>
      @nodeList[@nodeList.length-1]

    run: =>
      @nodeList = []
      @addNode("text")
      @_getNodes()
      @_cleanNodes()
      @_generateHtml()

    _getNodes: =>
      for c, i in @string
        @i = i
        unless @isKeyCharacter(c)
          @currentNode().write(c)
        else
          @_handleKeyCharacter(c)

    _cleanNodes: =>
      delList = []
      for node, i in @nodeList
        if node.value.length is 0
          delList.push i

      for i in delList
        @nodeList.splice(i, 1)

    _generateHtml: =>
      h = new BBCodeParser.ToHtml(@nodeList, BBCodeParser::getTags())

    peek: (ahead=1)=>
      @string[@i+ahead]

    _handleKeyCharacter: (c)=>
      switch c
        when "["
          tagType = if @peek() == "/"
            "tagEnd"
          else
            "tagStart"
          @addNode(tagType)
        when "]"
          @addNode("text")


    isKeyCharacter: (c)=>
      @keyCharacters.indexOf(c) >= 0

    keyCharacters: ["[", "]"]

  class Node
    constructor: (@type)->
      @value      = ""
      @outputSafe = false

    write: (c)=>
      @value += c

    output: =>
      @outputSafe = true

    isType: =>
      for t in arguments
        return true if t == @type
      false

    tagName: =>
      if @isType("tagStart")
        @value.split(/(?: |\=)/)[0]
      else if @isType("tagEnd")
        @value.slice(1, @value.length-1)

    toBBCode: =>
      console.log "converting node to bbcode"
      if @isType("text")
        @value
      else if @isType("tagStart", "tagEnd")
        "[#{ @value }]"

  class exports.BBCodeParser.ToHtml
    constructor: (@nodeList, @tagList)->

    run: =>
      output = ""
      for node, i in @nodeList
        console.log ["handling node", node]
        continue if node.outputSafe
        if node.isType("text")
          output+= node.value
        else if node.isType("tagStart")
          tagName = node.tagName()
          if @tagList[tagName]
            output+= @tagList[tagName].apply(this, [node, @nodeList[i+1]])
        else
          output+= ""
      output

  BBCodeParser::addTag = (name, callback1)=>
    @tagList || @tagList = {}
    @tagList[name] = callback1
    true

  BBCodeParser::getTags = =>
    @tagList || {}

  BBCodeParser::rmTag = (name)=>
    @tagList || @tagList = {}
    delete @tagList[name]

  null

)(window)
