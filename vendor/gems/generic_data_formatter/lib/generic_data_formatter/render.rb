module GenericDataFormatter
  module Render
    class HTML < Redcarpet::Render::HTML
      include Redcarpet::Render::SmartyPants

      def block_code(code, language)
        if language == 'math'
          "$$ #{ERB::Util.html_escape code} $$"
        else
          begin
            Pygments.highlight(code, lexer: language)
          rescue MentosError
            "<pre>#{ERB::Util.html_escape code}</code>"
          end
        end
      end
    end
  end
end
