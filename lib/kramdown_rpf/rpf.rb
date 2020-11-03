require 'kramdown'

module RPF
  module Plugin
    module Kramdown
      YAML_FRONT_MATTER_REGEXP = /\n\s*---\s*\n(.*?)---(.*)/m
      RADIO_REGEXP = /\((?<check>[\sx*]{0,1})\)\s*(?<text>.*)/m
      CHOICE_BLOCK_REGEXP = %r{^(?=#{::Kramdown::Parser::Kramdown::OPT_SPACE}- \([\sx*]?\)\s*.*)}m
      FEEDBACK_REGEXP_PARTIAL = "#{::Kramdown::Parser::Kramdown::OPT_SPACE}---[ \t]*feedback[ \t]*---(.*?)---[ \t]*\/feedback[ \t]*---"
      CHOICE_FEEDBACK_REGEXP = %r{#{FEEDBACK_REGEXP_PARTIAL}}m
      SINGLE_FEEDBACK_REGEXP = %r{\A#{FEEDBACK_REGEXP_PARTIAL}}m
      QUESTION_REGEXP = %r{(.*?)^#{::Kramdown::Parser::Kramdown::OPT_SPACE}---[ \t]*choices[ \t]*---(.*?)---[ \t]*\/choices[ \t]*---}m

      KRAMDOWN_OPTIONS = {
        input:              'KramdownRPF',
        parse_block_html:   true,
        syntax_highlighter: nil,
      }.freeze

      def self.convert_challenge_to_html(challenge)
        ::Kramdown::Document.new(challenge, KRAMDOWN_OPTIONS).to_html
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
        pre_attrs         = ['dir="ltr"']

        filename_html = "<div class=\"c-code-filename\">#{filename}</div>" if filename

        pre_attrs << 'class="line-numbers"' if line_numbers
        pre_attrs << "data-start=\"#{line_number_start}\"" if line_number_start
        pre_attrs << "data-line=\"#{line_highlights}\"" if line_highlights

        pre_attrs_html = ' ' + pre_attrs.join(' ') if pre_attrs.size.positive?

        <<~HEREDOC
          #{filename_html}
          <pre#{pre_attrs_html}><code class="language-#{language}" dir="ltr">#{code}</code></pre>
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

      def self.convert_new_page_to_html
        ::Kramdown::Document.new("<div class=\"c-print-page-break\" />", KRAMDOWN_OPTIONS).to_html
      end

      def self.convert_no_print_to_html(content)
        ::Kramdown::Document.new("<div class=\"u-no-print\">\n#{content}</div>", KRAMDOWN_OPTIONS).to_html
      end

      def self.convert_print_only_to_html(content)
        ::Kramdown::Document.new("<div class=\"u-print-only\">\n#{content}</div>", KRAMDOWN_OPTIONS).to_html
      end

      def self.convert_knowledge_quiz_question_to_html(question, _indent)
        question_match = QUESTION_REGEXP.match(question)
        return '' if question_match.nil? || question_match.length < 2

        question_blurb = KnowledgeQuiz.convert_question_blurb_to_html(question_match[1])

        choice_feedback = KnowledgeQuiz.convert_choices_to_html(question_match[2].strip)

        <<~HEREDOC
          <form class="knowledge_quiz__question">
            <fieldset>
              <legend>#{question_blurb[:legend]}</legend>
              <div class="knowledge_quiz__blurb">
                #{question_blurb[:blurb].strip}
              </div>
              #{choice_feedback[:choice_html].strip}
            </fieldset>
            #{choice_feedback[:feedback_html].strip}
            <input type="button" name="Submit" value="submit" />
          </form>
        HEREDOC
      end

      def self.convert_quiz_to_html(quiz)
        content = YAML_FRONT_MATTER_REGEXP.match(quiz)
        return '' if content.nil? || content.length() < 2

        details = YAML.safe_load(content[1])
        question = details['question']

        choices = YAML.safe_load(content[2])
        choice_texts = choices.map do |choice| 
          match = RADIO_REGEXP.match(choice)
          match ? match['text'] : nil
        end

        radio_inputs = choice_texts.compact.map.with_index(1) do |text, index|  
          <<~HEREDOC
            <label class="c-project-quiz__label" for="choice-#{index}">#{text}</label>
                  <input class="c-project-quiz__input" name="quiz-choice" type="radio" id="choice-#{index}" value="choice-#{index}" />
          HEREDOC
        end

        <<~HEREDOC
          <div class="c-project-quiz">
            <form class="c-project-quiz__form" action="#">
              <h3 class="c-project-quiz__heading">
                #{question}
              </h3>

              <div class="c-project-quiz__content">
                #{radio_inputs.join("      ").strip}
              </div>

              <div class="c-project-quiz__button-bar"></div>
            </form>
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

      module KnowledgeQuiz
        def self.convert_feedback_to_html(feedback, index = nil)
          id = 'feedback'
          id += "-for-choice-#{index + 1}" unless index.nil?
          <<~HEREDOC
            <li class="knowledge_quiz__feedback-item" id="#{id}">
            #{::Kramdown::Document.new(feedback.strip, KRAMDOWN_OPTIONS).to_html.strip}
            </li>
          HEREDOC
        end
  
        def self.convert_label_to_html(label, index, checked)
          number = index + 1
          <<~HEREDOC
            <label for="choice-#{number}">#{::Kramdown::Document.new(label, KRAMDOWN_OPTIONS).to_html.strip}</label>
            <input type="radio" name="answer" value="#{number}" id="choice-#{number}" #{checked ? 'checked': ''}/>
          HEREDOC
        end
  
        def self.convert_choices_to_html(text)
          choices = text.split(CHOICE_BLOCK_REGEXP)
          choice_html = ''
          feedback_html = ''
  
          single_feedback_match = SINGLE_FEEDBACK_REGEXP.match(choices[0])
          unless single_feedback_match.nil?
            feedback_html += convert_feedback_to_html(single_feedback_match[1].strip, nil)
            choices.shift
          end

          choices.each.with_index do |choice, index|
            choice_match = RADIO_REGEXP.match(choice)

            next unless choice_match && choice_match['text']

            choice_with_feedback = choice_match['text'].strip.split(CHOICE_FEEDBACK_REGEXP)

            checked = choice_match['check'] == 'x' || choice_match['check'] == '*'
            choice_html += convert_label_to_html(choice_with_feedback[0], index, checked)

            next if choice_with_feedback.length() < 2

            feedback_html += convert_feedback_to_html(choice_with_feedback[1].strip, index)
          end

          if feedback_html.size.positive?
            feedback_html = <<~HEREDOC
              <ul class="knowledge_quiz__feedback">
                #{feedback_html.strip}
              </ul>
            HEREDOC
          end
  
          { choice_html: choice_html, feedback_html: feedback_html}
        end
  
        def self.convert_question_blurb_to_html(text)
          legend = 'Question'
          blurb = text.strip
          front_matter_match = YAML_FRONT_MATTER_REGEXP.match(text)
  
          unless front_matter_match.nil?
            front_matter = YAML.safe_load(front_matter_match[1])
            legend = front_matter['legend'] || legend
            blurb = front_matter_match[2]
          end
  
          {
            legend: legend,
            blurb: ::Kramdown::Document.new(blurb, KRAMDOWN_OPTIONS).to_html
          }
        end
      end
    end
  end
end
