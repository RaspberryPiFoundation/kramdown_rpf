module RPF
  module Plugin
    module Kramdown
      YAML_FRONT_MATTER_REGEXP = /\n\s*---\n(.*?)---(.*)/m
      KRAMDOWN_OPTIONS = {
        input:              'KramdownRPF',
        parse_block_html:   true,
        syntax_highlighter: nil,
      }.freeze

      def self.convert_challenge_to_html(challenge)
        ::Kramdown::Document.new("<div class=\"challenge\">\n#{challenge}</div>", KRAMDOWN_OPTIONS).to_html
      end

      def self.convert_code_to_html(code_block)
        code_block =~ YAML_FRONT_MATTER_REGEXP
        meta       =  YAML.safe_load(Regexp.last_match(1))

        language          = meta['language']
        filename          = meta['filename'] || nil
        filename_html     = nil
        line_numbers      = meta['line_numbers'] || false
        line_number_start = meta['line_number_start'] || nil
        line_highlights   = meta['line_highlights'] || nil
        code              = Regexp.last_match(2)
        pre_attrs         = []

        if (filename)
          filename_html = "<div class=\"c-code-filename\">#{filename}</div>"
        end

        if (line_numbers)
          pre_attrs << 'class="line-numbers"'
        end

        if (line_number_start)
          pre_attrs << "data-start=\"#{line_number_start}\""
        end

        if (line_highlights)
          pre_attrs << "data-line=\"#{line_highlights}\""
        end

        if (pre_attrs.size > 0)
          pre_attrs_html = ' ' + pre_attrs.join(' ')
        end

        <<~HEREDOC
          #{filename_html}
          <pre#{pre_attrs_html}><code class="language-#{language}">#{code}</code></pre>
        HEREDOC
      end

      def self.convert_collapse_to_html(collapse)
        collapse       =~ YAML_FRONT_MATTER_REGEXP
        details        = YAML.safe_load(Regexp.last_match(1))
        title          = details['title']
        content        = Regexp.last_match(2)
        parsed_content = ::Kramdown::Document.new(content.strip, KRAMDOWN_OPTIONS).to_html

        <<~HEREDOC
          <div class="c-project-panel c-project-panel--ingredient">
            <h3 class="c-project-panel__heading js-project-panel__toggle">
              #{title}
            </h3>

            <div class="c-project-panel__content u-hidden">
              #{parsed_content}
            </div>
          </div>
        HEREDOC
      end

      def self.convert_hint_to_html(hint)
        parsed_hint = ::Kramdown::Document.new(hint.strip, KRAMDOWN_OPTIONS).to_html

        <<~HEREDOC
          <div class="c-project-panel__swiper-slide">
            #{parsed_hint}
          </div>
        HEREDOC
      end

      def self.convert_hints_to_html(hints)
        parsed_hints = ::Kramdown::Document.new(hints.strip, KRAMDOWN_OPTIONS).to_html

        <<~HEREDOC
          <div class="c-project-panel c-project-panel--hints">
            <h3 class="c-project-panel__heading js-project-panel__toggle">
              #{I18n.t('kramdown_rpf.hint_title')}
            </h3>

            <div class="c-project-panel__content js-project-panel--initialise-swiper u-hidden">
              <div class="c-project-panel__swiper">
                <div class="c-project-panel__swiper-wrapper">
                  #{parsed_hints.strip}
                </div>

                <div class="c-project-panel__swiper-pagination">
                  <span class="c-project-panel__swiper-bullet"></span>
                  <span class="c-project-panel__swiper-bullet"></span>
                  <span class="c-project-panel__swiper-bullet"></span>
                </div>

                <div class="c-project-panel__swiper-button c-project-panel__swiper-button--next"></div>
                <div class="c-project-panel__swiper-button c-project-panel__swiper-button--prev"></div>
              </div>
            </div>
          </div>
        HEREDOC
      end

      def self.convert_save_to_html
        <<~HEREDOC
          <div class="c-project-panel c-project-panel--save">
            <h3 class="c-project-panel__heading">
              #{I18n.t('kramdown_rpf.save')}
            </h3>
          </div>
        HEREDOC
      end

      def self.convert_task_to_html(task)
        parsed_task = ::Kramdown::Document.new(task.strip, KRAMDOWN_OPTIONS).to_html

        <<~HEREDOC
          <div class="c-project-task">
            <input class="c-project-task__checkbox" type="checkbox" />
            <div class="c-project-task__body">
              #{parsed_task}
            </div>
          </div>
        HEREDOC
      end
    end
  end
end
