( (exports)->
	"use strict"

	class exports.Tagger

		constructor: (@input, @config={})->
			@t = exports.Tools
			@_wrapInput()
			@_bindEvents()

		keyDownCallback: (event, item)->
			if ["space","comma"].indexOf(@t.keyMap[event.which]) > -1
				v = @input.val()
				v = v.replace(/\s*$/, "").replace(/^\s*/, "")
				@_createNewTag v
				@input.val("")
			if @t.keyMap[event.which] is "backspace" and @input.val().length is 0
				@_removeLastTag()

		blurCallback: ->
			v = @input.val()
			v = v.replace(/\s*$/, "").replace(/^\s*/, "")
			return if v.length is 0
			@_createNewTag v
			@input.val("")

		formSubmitCallback: ->
			@blurCallback()
			tagRender = []
			@wrap.children('.tag').each (_,e)->
				tagRender.push $(e).text()
			@input.val tagRender.join(',')

		_wrapInput: ->
			if @config.wrapper is undefined
				@input.wrap "div.tag_box"
				@wrap = @input.parent()
			else
				@wrap = @config.wrapper

			@wrap.prepend("<span class='pointer'></span>")
			@pointer = @wrap.children('span.pointer')

		_createNewTag: (tagvalue)->
			v = @t.escapeHTML(tagvalue)
			return if @_tagExists v
			return unless @_validateTag v
			@pointer.before("<a class='tag'>#{v}<span class='arrow arrow_bg'></span><span class='arrow'></span></a>")
			a = @wrap.children(".tag")
			$(a[a.length-1]).on 'click', (e)->
				$(e).remove()

		_removeTag: (tagvalue)->
			v = @t.escapeHTML(tagvalue)
			@wrap.children('.tag').each (_,e)->
				if $(e).text() == v
					$(e).remove()

		_validateTag: (t)->
			return false if t.length is 0
			v = true
			@_disallowedCharacters.forEach (c)->
				v = false if t.search(c) > -1
			v

		_removeLastTag: ->
			$tags = @wrap.children '.tag'
			$($tags[$tags.length-1]).remove()

		_tagExists: (t)->
			r = false
			@wrap.children('.tag').each (_,e)->
				if($(e).text() is t)
					r = true
			r

		_bindEvents: (onlyTags=false)->
			@input.on("keydown", this, (event)->
				event.data.keyDownCallback(event, this)
			)
			@input.on("blur", this, (event)->
				event.data.blurCallback(event, this)
			)
			@wrap.on("click", this, (event)->
				event.data.input.select()
			)
			if @config.form
				@config.form.on("submit", this, (event)->
					tagRender
				)

		_disallowedCharacters: [',', /[^A-Za-z\-\_0-9\.]/]

)(window.Generic)
