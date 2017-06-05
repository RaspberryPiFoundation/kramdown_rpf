module RPF
  module Plugin
    module Kramdown
      YAML_FRONT_MATTER_REGEXP = /\n\s*---\n(.*)---(.*)/m
      KRAMDOWN_OPTIONS = {
        coderay_css: :class, coderay_line_numbers: nil, parse_block_html: true, input: 'KramdownRPF'
      }.freeze

      def self.convert_challenge_to_html(challenge)
        ::Kramdown::Document.new(
          "<div class=\"challenge\">\n#{challenge}</div>",
          KRAMDOWN_OPTIONS
        ).to_html
      end

      def self.convert_collapse_to_html(collapse)
        collapse =~ YAML_FRONT_MATTER_REGEXP
        details = YAML.safe_load(Regexp.last_match(1))
        title = details['title']
        content = Regexp.last_match(2)
        parsed_content = ::Kramdown::Document.new(
          content.strip,
          KRAMDOWN_OPTIONS
        ).to_html
        <<~HEREDOC
          <div class="panel js-collapse">
            <div class="panel-heading drawer js-collapse">
              <div class="panel-heading-text js-collapse">
                <h4 class="js-collapse">#{title}</h4>
              </div>
              <div class="panel-heading-status status-down js-collapse">
              </div>
            </div>
            <div class="panel-content hidden">
              #{parsed_content}
            </div>
          </div>
        HEREDOC
      end

      def self.convert_hint_to_html(hint)
        parsed_hint = ::Kramdown::Document.new(
          hint.strip,
          KRAMDOWN_OPTIONS
        ).to_html
        "<div class=\"swiper-slide\">\n#{parsed_hint}</div>"
      end

      def self.convert_hints_to_html(hints)
        parsed_hints = ::Kramdown::Document.new(
          hints.strip,
          coderay_css: :class, coderay_line_numbers: nil, parse_block_html: true, input: 'KramdownRPF'
        ).to_html
        <<~HEREDOC
          <div class="panel hint js-collapse">
            <div class="panel-heading drawer js-collapse">
              <div class="panel-heading-image js-collapse">
              </div>
              <div class="panel-heading-text js-collapse">
                <h4 class="js-collapse">I need a hint</h4>
              </div>
              <div class="panel-heading-status status-down js-collapse">
              </div>
            </div>
            <div class="panel-content hidden">
              <div class="swiper-container">
                <div class="swiper-wrapper">
                  #{parsed_hints.strip}
                </div>
                <div class="swiper-pagination"></div>
                <div class="swiper-button-next"></div>
                <div class="swiper-button-prev"></div>
              </div>
            </div>
          </div>
        HEREDOC
      end
    end
  end
end
