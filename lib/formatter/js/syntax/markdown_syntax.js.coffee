#= require ../parser/markdown_parser.js
( (exports)->

	class MarkdownSyntax
		afterConstructorCallback: (@editor)->
			@editor.info.linkIncrement = 0

		render: (text)->
			exports.Parsers.MarkdownParser.toHTML(text)

		supportsPreview: true

		fromLastNewLine: (text,fromPos=text.length)->
			console.log ["called with:", text, fromPos]
			console.log ["text.length:", text.length]

			if text.indexOf("\n") is -1
				text + "\n"
			else
				text.substring(text.lastIndexOf("\n", fromPos))

		needsTwoLines: (text, fromPos=text.length)->
			@fromLastNewLine(text, fromPos) isnt "\n"

		iconList:
			bold: "B",
			italic: "<span style='font-style:italic'>I</span>",
			code: "{}",
			link: "a",
			horizontal_rule: "--",
			header: "#"

		eventHandlers: {
			iconPress:
				bold: ((m)->
					s = m.element.getSelection()
					m.element.setSelection("**#{s}**")

					cPos = m.element.getPosition()
					console.log cPos
					m.element.setPosition(cPos.start-2, cPos.end-2)
				),
				italic: ((m)->
					s = m.element.getSelection()
					m.element.setSelection("_#{s}_")

					cPos = m.element.getPosition()
					console.log cPos
					m.element.setPosition(cPos.start-1, cPos.end-1)
				),
				code: ((m)->
					s = m.element.getSelection()
					pos = m.element.getPosition()
					t = m.element.val()

					isInline = @needsTwoLines(t, pos.start)
					if s.length > 0 or isInline
						m.element.setSelection("`#{s}`")
						m.element.setPosition(pos.start+1, pos.end+1)
					else
						#twoLines = @needsTwoLines(t, t.lastIndexOf("\n")-1)
						m.element.setSelection("\n    insert code here")
						m.element.setPosition(pos.start - 16, pos.start)
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

					m.element.setSelection("[#{desc}][#{m.info.linkIncrement}]")
					cPos = m.element.getPosition()
					m.element.val(m.element.val() + "\n\n\n[#{m.info.linkIncrement}]: #{link}")
					m.element.setPosition(cPos.start, cPos.end)
					m.info.linkIncrement++
				),
				horizontal_rule: ((m)->
					m.element.setSelection("\n\n---")
				)
				header: ((m)->
					e = m.element
					s = e.getSelection()
					cPos = e.getPosition()
					twoLines = @needsTwoLines(e.val(), cPos.start)
					console.log "twoLines: #{twoLines}"

					if s.length == 0
						e.setSelection("\n#{ if twoLines then "\n" else "" }## header text here ##")
						e.setPosition(cPos.start+4+twoLines, cPos.end+20+twoLines)
					else
						e.setSelection("\n#{ if twoLines then "\n" else "" }## #{s} ##")
				)
			keyUp:
				# enter
				13: ((m)->
					e = m.element
					p = e.getPosition()
					lastIndex = e.val().lastIndexOf("\n")

					console.log "last index: " + lastIndex
					console.log "p.start: " + p.start

					line = @fromLastNewLine(e.val(), lastIndex-(p.start-lastIndex))
					console.log [line]
					m = line.match(/^\n?((?:\s|\>)+)(?:.*?)\n?$/)
					console.log m

					if m isnt null and m[1] != "\n"
						e.setSelection(m[1])
				),
				# tab
				9: ((m, e)->
					e = m.element
					cPos = e.getPosition()
					t = e.val()

					line = @fromLastNewLine(t, cPos)
					match = line.match(/^\n?(>+)(?:.*)\n?$/)

					if match isnt null and match[1].length > 0
						m.element.setPosition(t.lastIndexOf("\n"), cPos.start)
						m.element.setSelection("\n#{match[1]}> ")
					else
						m.element.setSelection("    ")
				)
			keyDown:
				# tab
				9: ((m, e)->
					e.preventDefault()
				),
				# b
				66: ((m, e)->
					if m.info.ctrlPressed
						e.preventDefault()
						@eventHandlers.iconPress.bold m
				),
				# i
				73: ((m, e)->
					if m.info.ctrlPressed
						e.preventDefault()
						@eventHandlers.iconPress.italic m
				)
		}

	exports.FormatRegister.addFormat "markdown", MarkdownSyntax

)(window)

# TODO:
# - add image
# - add more stuff
# - test!
