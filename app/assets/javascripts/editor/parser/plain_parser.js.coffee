( (exports)->

  class exports.Parsers.PlainParser

    toHTML: (text)->
      "<p>"+exports.Tools.escapeHTML(text)+"</p>"

)(window.Generic)
