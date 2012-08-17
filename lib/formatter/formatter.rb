
##
# Formatter is a formatting engine for generic forums.  Its basic
# purpose is to take a piece of text and its format and turn it into
# what it needs to be.
#
# Formatter also has roots in javascript, as the Editor for the
# formats.  This editor is supposed to be a WYSIWYG editor, with an
# output preview (depending on if the format has javascript support).
class Formatter

	# The format the text is in.  Something like "markdown", :plain, or
	# "bbcode" (as that's what generic forums inheritly supports).
	attr_accessor :format

	# The raw text that is in +:format+.
	attr_accessor :raw

	# The format register to use when outputting.  Really shouldn't need
	# to be changed.
	attr_accessor :register

	def initialize(plain, format)
		@format   = format
		@raw      = raw
		@register = ::Formatter::Register
	end

	def render(output=:html)
		@register.render(@raw, @format, output)
	end
end

require "#{Rails.root}/lib/formatter/register"
