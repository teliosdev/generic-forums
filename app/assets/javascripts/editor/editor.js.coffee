( (exports)->

	# The editor class; creates a WYSIWYG editor from a basic text box
	# and a defined syntax.
	class exports.Editor

		# public methods

		# constructor for the editor class.  Calls changeSyntax.
		# +@element+ is the target element, +@syntaxType+ is the textual
		# representation of the syntax to use, i.e. "bbcode" or "plain".
		#
		# calls +_wrapElement+ before calling +changeSyntax+.
		constructor: (@element, @syntaxType, @opts)->
			@hadPreviousSyntax = false
			@t = exports.Tools
			@info = { ctrlPressed: false }
			@_wrapElement()
			@changeSyntax(@syntaxType)

		# change the syntax to another type.  If the editor had a previous
		# syntax, it cleans that one up first (i.e. remove the icons bar).
		# Calls all of the nessicary functions to change the syntax.
		changeSyntax: (syntax, opts=@opts)->
			if @hadPreviousSyntax
				@_cleanSyntax()

			ret = @_parseOpts(opts)
			@syntax = exports.FormatRegister.findFormat(syntax)
			return if @syntax == null
			@_addIcons(ret)
			@_bindEvents()
			@_addOutputView(ret)
			@updateOutput()
			if @syntax.afterConstructorCallback isnt undefined
				@syntax.afterConstructorCallback(this)
			@hadPreviousSyntax = true

		# The callback handler for the icons that are added in
		# +_addIcons+.  Checks the syntax's eventHandlers
		# (@syntax.eventHandlers.iconPress) for the icon's name, and
		# triggers both that and the +any+ event.  Does the same
		# for this class's event handlers.
		iconCallback: (icon, event)->
			n = icon.data('name')
			#console.log "Icon Click Event for #{n} Fired"
			@_findAndCall([n, 'any'], @syntax.eventHandlers.iconPress, @syntax, [this, icon, event])
			@_findAndCall([n, 'any'], @eventHandlers.iconPress, @this, [this, icon, event])

		# See iconCallback.  For keyUp.
		keyUpCallback: (event)->
			#console.log "Key Up Event For #{@t.keyMap[event.which] || event.which} Fired"
			@_findAndCall([event.which, 'any'], @syntax.eventHandlers.keyUp, @syntax, [this, event])
			@_findAndCall([event.which, 'any'], @eventHandlers.keyUp, @this, [this, event])

		# See iconCallback. For keyDown.
		keyDownCallback: (event)->
			#console.log "Key Down Event For #{@t.keyMap[event.which] || event.which} Fired"
			@_findAndCall([event.which, 'any'], @syntax.eventHandlers.keyDown, @syntax, [this, event])
			@_findAndCall([event.which, 'any'], @eventHandlers.keyDown, @this, [this, event])

		# Update the output preview.  Does nothing if the syntax doesn't
		# support it.
		updateOutput: ()->
			return unless @syntax.supportsPreview
			text = @render(@element.val())
			if text.length == 0
				text = "<p class='gray'>nothing yet...</p>"
			@output.html(text)

		# Render the text based on the syntax.  Returns the html-escaped
		# version if the syntax doesn't support it.
		render: (text)->
			return @t.escapeHTML(text) unless @syntax.supportsPreview
			@syntax.render(text)

		# protected methods

		# Parse the options that were passed by opts
		_parseOpts: (opts)->
			return {} unless opts isnt null
			ret = {}
			unless opts["iconContainer"] is null
				@iconContainer = opts["iconContainer"]
				ret["iconContainer"] = true

			unless opts["output"] is null
				@output = opts["output"]
				ret["output"] = true

			return ret

		# Adds the icons and the icon bar to the top of the editor.  Takes
		# the list from the syntax.
		_addIcons: (ret)->
			# we don't need to do anything if there is no iconList from the
			# syntax.
			return if @syntax["iconList"] == null

			unless ret["iconContainer"]
				@wrapper.prepend "<div class='icon_container'></div>" unless @wrapper.children(".icon_container").length > 0
				@iconContainer = @wrapper.children ".icon_container"

			for name, contents of @syntax.iconList
				@iconContainer.append "<a class='icon' data-name='#{@t.escapeHTML(name)}' title='#{@t.escapeHTML(name.replace(/\_/g," "))}'>#{contents}</a>"

		# Bind all events for jQuery, for @iconContainer's +a+ children
		# and for key presses for the syntax.
		_bindEvents: ()->
			@iconContainer.children("a").on("click", this, (event)->
				event.data.iconCallback $(this), event
			)
			@element.on("keyup", this, (event)->
				event.data.keyUpCallback event
			)
			@wrapper.on("keydown", this, (event)->
				event.data.keyDownCallback event
			)

		# Wraps the element in a wrapper for control.  This should not be
		# done more than once.
		_wrapElement: ()->
			randomName = (Math.random() * 10000).toFixed()
			@element.wrap('<div class="editor_wrapper" />') unless @element.parent().hasClass("editor_wrapper")
			@wrapper = @element.parent(".editor_wrapper")

		# Adds the output view to the wrapper if its needed.  Sets
		# +@output+ to the output view if the syntax supports output,
		# otherwise it sets it to a non-existant element.
		_addOutputView: (ret)->
			if @syntax.supportsPreview
				if ret["output"] or @hadPreviousSyntax
					@output.text("")
					return @output.show()
				@wrapper.append("<div class='output_wrapper'></div>") unless @wrapper.children(".output_wrapper").length > 0
				@wrapper.children('.output_wrapper').append("<div class='editor_output'></div>")
				@output = @wrapper.children('.output_wrapper').children('.editor_output')
			else
				@output = $ "<div />"


		# Find functions of the object for the key +key+, where +key+ can
		# be an array or a string.  +scope+ is what +this+ will refer to,
		# and +args+ are the arguments passed to the function.
		_findAndCall: (key, object, scope, args)->
			if not key instanceof Array
				key = [key]
			for v in key
				if object[v]
					object[v].apply(scope, args)

		# Clean the editor box up so another syntax can be applied.  This
		# removes the output view, and removes the icons.
		_cleanSyntax: ()->
			#@iconContainer.remove()
			@wrapper.children(".output_wrapper").hide()
			@iconContainer.children("a").remove()

		eventHandlers:
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

	exports.Editor.VERSION = "2.3.1"

	class FormatRegister

		constructor: ()->
			@formats = {}

		addFormat: (format, syntax)->
			@formats[format] = syntax

		removeFormat: (format)->
			delete @formats[format]

		findFormat: (format)->
			return null if @formats[format] is undefined
			new @formats[format]()

	exports.FormatRegister = new FormatRegister()

	# A basic class containing tools such as HTML-escape.
	class Tools

		escapeHTML: (text)->
			for tag in @_htmlEntities
				text.replace(tag[0], tag[1])
			text

		keyMap:
			13 : "enter",
			9  : "tab",
			66 : "b",
			73 : "i",
			17 : "ctrl",
			84 : "t",
			8  : "backspace",
			65 : "a",
			88 : "x",
			70 : "f",
			32 : "space",
			188: "comma"

		_htmlEntities: [
			[/&/g, "&amp;" ],
			[/>/g, "&lt;"  ],
			[/</g, "&gt;"  ],
			[/"/g, "&quot;"],
			[/'/g, "&#39;" ]
		]

	exports.Tools = new Tools()

	# Just a namespace for defining all of the parsers.
	exports.Parsers = {}

)(window)
