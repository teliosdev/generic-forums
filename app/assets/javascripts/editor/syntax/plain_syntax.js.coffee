#= require ../parser/plain_parser
( (exports)->

	class PlainSyntax

		afterConstructorCallback: ()->
      return

    render: (text)->
      (new exports.Parsers.PlainParser).toHTML(text)

    supportsPreview: true

    eventHandlers:
      iconPress: {}

      keyUp: {}

      keyDown: {}

	exports.FormatRegister.addFormat "plain", PlainSyntax

)(window)
