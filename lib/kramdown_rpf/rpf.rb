module RPF
  module Plugin
    module Kramdown
      def self.convert_challenge_to_html(challenge)
        ::Kramdown::Document.new(
          "<div class=\"challenge\">\n#{challenge}</div>",
          coderay_css: :class, coderay_line_numbers: nil, parse_block_html: true, input: 'GFM'
        ).to_html
      end
    end
  end
end
