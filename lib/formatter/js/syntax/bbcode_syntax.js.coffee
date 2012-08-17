( (exports)->

	class window.BbCodeSyntax
		afterConstructorCallback: (@editor)->
			@editor.info.linkIncrement = 0

		iconList: {
			bold: "B",
			italic: "<span style='font-style:italic'>I</span>",
			code: "{}",
			link: "a",
			header: "#"
		}

		supportsPreview: false

		eventHandlers: {
			iconPress:
				bold: ((m)->
					s = m.element.getSelection();
					m.element.setSelection("[B]#{s}[/B]")
					cPos = m.element.getPosition()[0]
					console.log cPos
					m.element.setPosition(cPos.start-2, cPos.end-2)
				),
				italic: ((m)->
					s = m.element.getSelection();
					m.element.setSelection("[I]#{s}[/I]")
					cPos = m.element.getPosition()
					console.log cPos
					m.element.setPosition(cPos.start-1, cPos.end-1)
				),
				code: ((m)->
					s = m.element.getSelection()
					if s.length > 0
						m.element.setSelection("`#{s}`")
					else
						m.element.setSelection("\n[code]\ninsert code here\n[/code]")
						pos = m.element.getPosition()
						m.element.setPosition(pos.start - (16+8), pos.start - 8)
				),
				link: ((m)->
					link = prompt "Link?"
					if link.length == 0
						return
					s = m.element.getSelection()
					unless s.length > 0
						desc = prompt "Description?"
					else
						desc = s
					if desc.length == 0
						return
					m.element.setSelection("[url=#{link}]#{desc}[/url]")
				)
				header: ((m)->
					s = m.element.getSelection()
					if s.length == 0
						cPos = m.element.getPosition()
						m.element.setSelection("\n[h2]header text here[/h2]")
						m.element.setPosition(cPos.start+5, cPos.end+(16+5))
					else
						m.element.setSelection("\n[h2]#{s}[/h2]")
				)
			keyUp:
				9: ((m, e)->
					m.element.setSelection("    ")
				),
				66: ((m, e)->
					if m.info.ctrlPressed
						e.preventDefault()
						console.log this
						@eventHandlers.iconPress.bold m
				),
				73: ((m, e)->
					if m.info.ctrlPressed
						e.preventDefault()
						@eventHandlers.iconPress.italic m
				)
			keyDown:
				9: ((m, e)->
					e.preventDefault()
				)
		}

	exports.FormatRegister.addFormat "bbcode", BbCodeSyntax

)(window)

# TODO:
# - add client-side parser
# - add more stuff
