class window.Editor

  constructor: (element)->
    @element = element

    @_addPreview()
    @_setupLinks()

  _addPreview: ->
    console.log "adding preview"

  _setupLinks: ->
