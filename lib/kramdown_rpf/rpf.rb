module RPF
  module Plugin
    module Kramdown
      YAML_FRONT_MATTER_REGEXP = /\n---\n(.*)\n---(.*)/m

      def self.convert_challenge_to_html(challenge)
        ::Kramdown::Document.new(
          "<div class=\"challenge\">\n#{challenge}</div>",
          coderay_css: :class, coderay_line_numbers: nil, parse_block_html: true, input: 'GFM'
        ).to_html
      end

      def self.convert_collapse_to_html(collapse)
        collapse =~ YAML_FRONT_MATTER_REGEXP
        details = YAML.safe_load(Regexp.last_match(1))
        content = Regexp.last_match(2).strip
        <<~HEREDOC
          <div class="panel js-collapse">
            <div class="panel-heading drawer js-collapse">
              <div class="panel-heading-image js-collapse">
                <img src="#{details['image']}" class="js-collapse">
              </div>
              <div class="panel-heading-text js-collapse">
                <h4 class="js-collapse">#{details['title']}</h4>
              </div>
              <div class="panel-heading-status status-down js-collapse">
              </div>
            </div>
            <div class="panel-content hidden">
              #{content}
            </div>
          </div>
        HEREDOC
      end
    end
  end
end
