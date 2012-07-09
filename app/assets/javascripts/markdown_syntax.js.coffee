#= require markdown_parser.js

class window.MarkdownSyntax
  afterConstructorCallback: (@editor)->
    @editor.info.linkIncrement = 0

  render: (text)->
    window.MarkdownParser.toHTML(text)

  iconList: {
    bold: "B",
    italic: "<span style='font-style:italic'>I</span>",
    code: "{}",
    link: "a",
    horizontal_rule: "--",
    header: "#"
  }

  eventHandlers: {
    iconPress:
      bold: ((m)->
        s = m.element.getSelection()[0];
        m.element.setSelection("**#{s}**")
        cPos = m.element.getPosition()[0]
        console.log cPos
        m.element.setPosition(cPos.start-2, cPos.end-2)
      ),
      italic: ((m)->
        s = m.element.getSelection()[0];
        m.element.setSelection("_#{s}_")[0]
        cPos = m.element.getPosition()[0]
        console.log cPos
        m.element.setPosition(cPos.start-1, cPos.end-1)
      ),
      code: ((m)->
        s = m.element.getSelection()[0];
        if s.length > 0
          m.element.setSelection("`#{s}`")
        else
          m.element.setSelection("\n    insert code here")
          pos = m.element.getPosition()[0]
          m.element.setPosition(pos.start - 16, pos.start)
      ),
      link: ((m)->
        link = prompt "Link?"
        if link.length == 0
          return
        s = m.element.getSelection()[0];
        unless s.length > 0
          desc = prompt "Description?"
        else
          desc = s
        if desc.length == 0
          return
        m.element.setSelection("[#{desc}][#{m.info.linkIncrement}]")
        cPos = m.element.getPosition()[0];
        m.element.val(m.element.val() + "\n\n\n[#{m.info.linkIncrement}]: #{link}")
        m.element.setPosition(cPos.start, cPos.end)
        m.info.linkIncrement++
      ),
      horizontal_rule: ((m)->
        m.element.setSelection("\n\n---")
      )
      header: ((m)->
        s = m.element.getSelection()[0]
        if s.length == 0
          cPos = m.element.getPosition()[0]
          m.element.setSelection("\n## header text here ##")
          m.element.setPosition(cPos.start+4, cPos.end+20)
        else
          m.element.setSelection("\n## #{s} ##")
      )
    keyUp:
      13: ((m)->
        e = m.element
        p = e.getPosition()[0]
        console.log e
        console.log "key event 13"
        console.log p
        line = e.val().substring(e.val().lastIndexOf("\n", p.start - 2)+1, e.val().lastIndexOf("\n", p.start)-1)
        console.log [line]
        m = line.match(/^((?:\s|\>)+)(?:.*?)$/)
        console.log m
        if m isnt null and m[1] != "\n"
          e.setSelection(m[1])
      ),
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
