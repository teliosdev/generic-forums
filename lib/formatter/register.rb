
##
# Register handles the registration of formats, and handles each one
# for output.
class Formatter::Register
	class << self

		# Register a new format with a handler.  You can either pass the
		# handler as an argument, or specify a block to call.  The handler
		# should follow the basic +Markdown+ class style interface.
		def register(format, klass, &block)
			@formats ||= {}
			@formats[format.to_sym] = klass || block
		end

		def render(text, format, output)
			return text unless @formats
			format = format.to_sym
			return text unless @formats[format]
			if @formats[format].is_a? Proc
				@formats[format].call(text, output)
			else
				@formats[format].new(text).send("to_#{output}")
			end
		end
	end
end
