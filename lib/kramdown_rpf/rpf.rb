require 'kramdown'

module RPF
  module Plugin
    module Kramdown
      YAML_FRONT_MATTER_REGEXP = /\n\s*---\s*\n(.*?)---(.*)/m
      RADIO_REGEXP = /\([\sx*]?\)\s*(?<text>.*)/
      CHOICE_BLOCK_REGEXP = %r{^(?=#{::Kramdown::Parser::Kramdown::OPT_SPACE}- \([\sx*]?\)\s*.*)}m
      FEEDBACK_REGEXP = %r{^#{::Kramdown::Parser::Kramdown::OPT_SPACE}---[ \t]*feedback[ \t]*---(.*?)---[ \t]*\/feedback[ \t]*---}m
      QUESTIONS_REGEXP = %r{^#{::Kramdown::Parser::Kramdown::OPT_SPACE}---[ \t]*question[ \t]*---(.*?)---[ \t]*\/question[ \t]*---}m
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

      def self.convert_knowledge_quiz_to_html(knowledge_quiz)
        knowledge_quiz =~ YAML_FRONT_MATTER_REGEXP

        details        = YAML.safe_load(Regexp.last_match(1))
        quiz_version   = details['quiz_version']

        ::Kramdown::Document.new(Regexp.last_match(2).strip, KRAMDOWN_OPTIONS.merge({ quiz_version: quiz_version})).to_html
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

      def self.convert_question_meta_to_html(options)
        question_number = options[:question_number]
        total_questions = options[:total_questions]

        if question_number < total_questions
          next_html = "<a href=\"q#{question_number + 1}\" class=\"button\">Next</a>"
        else
          next_html = '<a href="end" class="button">Finish</a>'
        end

        <<~HEREDOC
          <input type="hidden" name="lang" value="en" />
          <input type="hidden" name="quiz_version" value="#{options[:quiz_version]}" />
          <input type="hidden" name="project_name" value="rock-band-with-dogs" />
          <input type="hidden" name="question" value="#{question_number}" />
          <!-- result is set client side, representing the correct/incorrect status shown in the browser -->
          <input type="hidden" name="result" value="" />
          <input type="button" name="Submit" value="submit" />
          #{next_html}
        HEREDOC
      end

      def self.convert_feedback_to_html(feedback, index = nil)
        id = 'feedback'
        id += "-for-choice-#{index + 1}" unless index.nil?
        <<~HEREDOC
          <li id="#{id}">
            #{::Kramdown::Document.new(feedback.strip, KRAMDOWN_OPTIONS).to_html}
          </li>
        HEREDOC
      end

      def self.convert_label_to_html(label, index)
        number = index + 1
        <<~HEREDOC
          <label for="choice-#{number}">#{label}</label>
          <input type="radio" name="answer" value="#{number}" id="choice-#{number}" />
        HEREDOC
      end

      def self.convert_choices_to_html(text)
        choices = text.split(CHOICE_BLOCK_REGEXP)

        choice_html = ''
        feedback_html = ''
        choices.each.with_index do |choice, index| 
          label_match = RADIO_REGEXP.match(choice)
          label = label_match ? label_match['text'] : nil
          choice_html += convert_label_to_html(label, index)
          feedback_match = FEEDBACK_REGEXP.match(choice)
          next if feedback_match.nil? || feedback_match.length() < 1

          feedback_html += convert_feedback_to_html(feedback_match[1].strip, index)
        end

        if feedback_html.size.positive?
          feedback_html = <<~HEREDOC
            <ul>
              #{feedback_html}
            </ul>
          HEREDOC
        end

        { choice_html: choice_html, feedback_html: feedback_html}
      end

      def self.convert_question_to_html(question, options)
        question_match = QUESTION_REGEXP.match(question)
        return '' if question_match.nil? || question_match.length() < 2

        question_blurb = ::Kramdown::Document.new(question_match[1].strip, KRAMDOWN_OPTIONS.merge(options)).to_html

        choice_feedback = convert_choices_to_html(question_match[2].strip)

        <<-HEREDOC
<form id="question-#{options[:question_number]}">
  <fieldset>
    <legend>Question #{options[:question_number]} of #{options[:total_questions]}</legend>
    <div class="question">
      #{question_blurb}
    </div>
    #{choice_feedback[:choice_html]}
  </fieldset>
  #{choice_feedback[:feedback_html]}
  #{convert_question_meta_to_html(options)}
</form>
        HEREDOC
      end

      def self.convert_questions_to_html(questions, options)
        questions_match = questions.scan(QUESTIONS_REGEXP)
        return '' if questions_match.nil? || questions_match.length() < 1

        total_questions = questions_match.length()
        question_html = ''
        questions_match.each.with_index do |question, index|
          question_html += convert_question_to_html(question[0].strip, options.merge({ question_number: (index + 1), total_questions: total_questions}))
        end

        question_html
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

    end
  end
end
