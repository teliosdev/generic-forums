( (exports)->

  class exports.Parsers.PlainParser

    toHTML: (text)->
      "<pre>"+exports.Tools.escapeHTML(text)+"</pre>"

)(window.Generic.Lib)
