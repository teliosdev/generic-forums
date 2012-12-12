class GenericForums::Formatter
  ##
  # Register handles the registration of formats, and handles each one
  # for output.
  class Register
    class << self

      # Register a new format with a handler.  You can either pass the
      # handler as an argument, or specify a block to call.  The handler
      # should follow the basic +Markdown+ class style interface.  Can
      # register different types, such as +quote+ or +render+.  +quote+
      # is used for quoting posts.
      def register(format=nil, type=:render, klass=nil, *opts, &block)
        unless format
          context = Context.new self
          context.instance_eval(&block)
        else
          @render ||= {}
          @render_opts ||= {}
          @quote ||= {}
          case type
          when :render
            _add_to_render format, klass, *opts, &block
          when :quote
            _add_to_quote  format, klass, *opts, &block
          end
        end
      end

      def render(text, format, output)
        return text unless @render
        format = format.to_sym
        return text unless @render[format]
        opts = @render_opts[format] || []
        if @render[format].is_a? Proc
          @render[format].call(text, output, opts)
        else
          @render[format].new(text, *opts).send("to_#{output}")
        end
      end

      def quote(text, format)
        format = format.to_sym
        return "" unless @quote and @quote[format]
        if @quote[format].is_a? Proc
          @quote[format].call(text)
        else
          @quote[format].new(text).send("quote")
        end
      end

      def format_list
        (@render ||= {}).keys
      end

      private

      def _add_to_render(format, klass, *opts, &block)
        @render[format.to_sym] = if klass
          klass
        else
          block
        end
        @render_opts[format.to_sym] = opts if opts.length > 0
      end

      def _add_to_quote(format, klass, *opts, &block)
        @quote[format.to_sym] = if klass
          klass
        else
          block
        end
      end

    end
  end

  class Register::Context

    attr_accessor :register
    def initialize(register)
      @register = register
    end

    def method_missing(method, *args, &block)
      register.register method, *args, &block
    end
  end
end

require "#{Rails.root}/lib/generic_forums/formatter/default"
