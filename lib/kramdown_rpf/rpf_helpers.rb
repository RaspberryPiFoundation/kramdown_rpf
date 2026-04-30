# frozen_string_literal: true

module RPF
  module Plugin
    module KramdownHelpers
      def block_content(block)
        block.is_a?(Hash) ? block[:content].to_s : block.to_s
      end

      def block_title(block)
        return nil unless block.is_a?(Hash)

        block[:title]
      end

      def code_block_details(code_block)
        return [code_block[:meta], code_block[:code]] if code_block.is_a?(Hash)

        code_block =~ RPF::Plugin::Kramdown::YAML_FRONT_MATTER_REGEXP
        [YAML.safe_load(Regexp.last_match(1)), Regexp.last_match(2)]
      end

      def code_filename_html(filename)
        return nil unless filename

        <<~HEREDOC
          <div class="c-code-filename">
            #{filename}
          </div>
        HEREDOC
          .strip
      end

      def code_pre_attrs_html(meta)
        line_numbers = normalise_boolean(meta['line_numbers'])
        line_number_start = meta['line_number_start'] || meta['line_numbers_start'] || nil
        line_highlights = normalise_line_highlights(meta['line_highlights'])
        pre_attrs = ['dir="ltr"']

        if line_numbers
          pre_attrs << 'class="line-numbers"'
        elsif line_numbers == false
          pre_attrs << 'class="no-line-numbers"'
        end

        pre_attrs << "data-start=\"#{line_number_start}\"" if line_number_start && line_numbers
        pre_attrs << "data-line-offset=\"#{line_number_start}\"" if line_highlights && line_number_start
        pre_attrs << "data-line=\"#{line_highlights}\"" if line_highlights

        " #{pre_attrs.join(' ')}"
      end

      def convert_callout_to_html(callout, type, default_title)
        title = block_title(callout) || default_title
        content = block_content(callout).strip
        markdown = "### #{title}\n#{content}"
        parsed_callout = ::Kramdown::Document.new(markdown.strip, RPF::Plugin::Kramdown::KRAMDOWN_OPTIONS).to_html

        <<~HEREDOC
          <div class="c-project-callout c-project-callout--#{type}">

          #{parsed_callout}
          </div>
        HEREDOC
      end

      def ends_with_blockquote?(content)
        content.rstrip.lines.last&.start_with?('>')
      end

      def normalise_boolean(value)
        return true if value == 'true'
        return false if value == 'false'

        value
      end

      def normalise_line_highlights(value)
        return nil if value.nil?

        value.to_s.gsub(/\s*,\s*/, ', ')
      end
    end
  end
end
