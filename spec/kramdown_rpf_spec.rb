# frozen_string_literal: true

require 'spec_helper'

RSpec.describe KramdownRPF do
  conversion_tests = %w[
    accordion/rfm_accordion
    accordion/rfm_accordion_with_code
    accordion/rfm_accordion_with_space
    accordion/rfm_accordion_in_challenge
    challenge/challenge
    challenge/rfm_challenge
    code/code
    code/code_default
    code/code_with_all_features
    code/code_with_angle_brackets
    code/code_with_filename
    code/code_with_line_numbers
    code/code_with_no_line_numbers
    code/code_with_line_highlights
    code/rfm_code_fenced
    collapse/collapse
    collapse/collapse_in_challenge
    collapse/collapse_music_box
    collapse/collapse_with_code
    collapse/collapse_with_space
    debug/rfm_debug
    hint/hint
    hint/hints
    hint/rfm_hint
    hint/rfm_hints
    knowledge_quiz/example_question
    knowledge_quiz/question_blocks_in_feedback
    knowledge_quiz/question_single_feedback
    microbit/microbit
    new_page/new_page
    no_print/no_print
    no_print/rfm_no_print
    print_only/print_only
    print_only/rfm_print_only
    quiz/quiz
    save/save
    save/rfm_save
    scratch/scratch2
    scratch/scratch3
    task/task
    task/task_with_hints
    task/task_with_ingredient
    task/rfm_task
    task/rfm_task_with_hints
    task/rfm_task_with_ingredient
    tip/rfm_tip
  ].freeze

  it 'has a version number' do
    expect(KramdownRPF::VERSION).not_to be_nil
  end

  describe 'conversions', skip: 'in favour of specification examples' do
    conversion_tests.each do |test_name|
      context test_name do
        subject(:test_result) do
          Kramdown::Document.new(
            File.read("examples/#{test_name}.md"),
            input: 'KramdownRPF',
            parse_block_html: true,
            syntax_highlighter: nil
          ).to_html
        end

        let(:reference_result) { File.read "examples/#{test_name}.html" }

        before { I18n.locale = 'en' }

        it 'is correctly converted' do
          expect(test_result.strip).to eq(reference_result.strip)
        end
      end
    end
  end

  # rubocop:disable RSpec/ExampleLength, RSpec/MultipleExpectations
  describe 'RFM syntax' do
    let(:kramdown_options) do
      {
        input: 'KramdownRPF',
        parse_block_html: true,
        syntax_highlighter: nil
      }
    end

    before { I18n.locale = 'en' }

    def convert(markdown)
      Kramdown::Document.new(markdown, kramdown_options).to_html
    end

    it 'leaves ordinary blockquotes unchanged' do
      markdown = <<~MARKDOWN
        > Ordinary quoted text
        >
        > Still quoted
      MARKDOWN

      expect(convert(markdown)).to eq(<<~HTML)
        <blockquote>
          <p>Ordinary quoted text</p>

          <p>Still quoted</p>
        </blockquote>
      HTML
    end

    it 'leaves ordinary fenced code blocks unchanged' do
      markdown = <<~MARKDOWN
        ```python
        print("Hello")
        ```
      MARKDOWN

      expect(convert(markdown)).to eq(<<~HTML)
        <pre><code class="language-python">print("Hello")
        </code></pre>
      HTML
    end

    it 'supports quoted RFM fenced code attributes' do
      markdown = <<~MARKDOWN
        ```python filename="button_press.py" line_numbers="true" line_number_start="3" line_highlights="3,5-6"
        print("Hello")
        ```
      MARKDOWN

      expect(convert(markdown)).to eq(<<~HTML)
        <div class="c-code-filename">
          button_press.py
        </div>
        <pre dir="ltr" class="line-numbers" data-start="3" data-line-offset="3" data-line="3, 5-6"><code class="language-python" dir="ltr">
        print(&quot;Hello&quot;)
        </code></pre>
      HTML
    end

    it 'renders a single RFM hint as a single hint slide' do
      markdown = <<~MARKDOWN
        > [!HINT]
        >
        > Try this
      MARKDOWN

      expect(convert(markdown)).to include('class="c-project-panel c-project-panel--hints"')
      expect(convert(markdown)).to include('class="c-project-panel__swiper-slide"')
      expect(convert(markdown).scan('c-project-panel__swiper-slide').length).to eq(1)
    end

    it 'groups adjacent RFM hints into one hints panel' do
      markdown = <<~MARKDOWN
        > [!HINT]
        >
        > Hint 1

        > [!HINT]
        >
        > Hint 2
      MARKDOWN

      expect(convert(markdown)).to include('class="c-project-panel c-project-panel--hints"')
      expect(convert(markdown).scan('c-project-panel__swiper-slide').length).to eq(2)
    end

    it 'supports nested RFM blocks' do
      markdown = <<~MARKDOWN
        > [!NOPRINT]
        >
        > > [!TASK]
        > >
        > > Do the nested task
      MARKDOWN

      result = convert(markdown)

      expect(result).to include('class="u-no-print"')
      expect(result).to include('class="c-project-task"')
      expect(result).to include('<p>Do the nested task</p>')
    end
  end
  # rubocop:enable RSpec/ExampleLength, RSpec/MultipleExpectations
end
