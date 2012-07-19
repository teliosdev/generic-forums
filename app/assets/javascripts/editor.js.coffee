#= require jquery-fieldselection.js

class window.Editor
  constructor: (@element, @syntax)->
    @_wrapElement()
    @_addIcons()
    @_bindElements()
    @_addOutputView()
    @info = { ctrlPressed: false }
    @syntax.afterConstructorCallback(this)

  _wrapElement: ->
    randomName = (Math.random() * 10000).toFixed()
    @element.wrap('<div id="wrapper_'+randomName+'" class="editor_wrapper" />')
    @wrapper = $ "#wrapper_#{randomName}"

  _addIcons: ->
    @wrapper.prepend("<div class='icon_container'></div>")
    @iconContainer = @wrapper.children ".icon_container"
    for name, contents of @syntax.iconList
      @iconContainer.append "<a class='icon' data-name='#{name}' title='#{name.replace(/\_/g," ")}'>#{contents}</a>"

  _bindElements: ->
    @iconContainer.children("a").on("click", this, (event)->
      event.data.iconCallback $(this), event
    )
    @element.on("keyup", this, (event)->
      event.data.keyUpCallback event
    )
    @wrapper.on("keydown", this, (event)->
      event.data.keyDownCallback event
    )

  _addOutputView: ->
    return unless @syntax.supportsPreview
    @wrapper.append("<div>Output:</div>")
    @wrapper.append("<div class='editor_output'></div>")
    @output = @wrapper.children('div.editor_output')
    @output.html(@render(@element.val()))

  updateOutput: ->
    return unless @syntax.supportsPreview
    @output.html(@render(@element.val()))

  render: (text)->
    return unless @syntax.supportsPreview
    @syntax.render(text)
    #window.MarkdownParser.toHTML(text)

  iconCallback: (icon, event)->
    n = icon.attr('data-name')
    @_findAndCall([n, 'any'], @syntax.eventHandlers.iconPress, @syntax, [this, icon, event])
    @_findAndCall([n, 'any'], @eventHandlers.iconPress, @this, [this, icon, event])

  keyUpCallback: (event)->
    console.log "Key Up Event For #{@keyMap[event.which] || event.which} Fired"
    @_findAndCall([event.which, 'any'], @syntax.eventHandlers.keyUp, @syntax, [this, event])
    @_findAndCall([event.which, 'any'], @eventHandlers.keyUp, @this, [this, event])

  keyDownCallback: (event)->
    console.log "Key Down Event For #{@keyMap[event.which] || event.which} Fired"
    @_findAndCall([event.which, 'any'], @syntax.eventHandlers.keyDown, @syntax, [this, event])
    @_findAndCall([event.which, 'any'], @eventHandlers.keyDown, @this, [this, event])

  _findAndCall: (key, object, scope, args)->
    if not key instanceof Array
      key = [key]
    for v in key
      if object[v]
        object[v].apply(scope, args)

  eventHandlers: {
    iconPress:
      any: ((m)->
        m.updateOutput()
      )
    keyUp:
      17: ((m)->
        m.info.ctrlPressed = false
      )
      any: ((m)->
        m.updateOutput()
      )
    keyDown:
      17: ((m)->
        m.info.ctrlPressed = true
      )
  }

  keyMap: {
    13: "enter",
    9: "tab",
    66: "b",
    73: "i",
    17: "ctrl",
    84: "t",
    8: "backspace",
    65: "a",
    88: "x",
    70: "f"
  }
