# frozen_string_literal: true

require 'spec_helper'

RSpec.describe KramdownRPF do
  KRAMDOWN_OPTIONS = {
    input: 'KramdownRPF',
    parse_block_html: true,
    syntax_highlighter: nil
  }.freeze

  CONVERSION_TESTS = %w[
    challenge/challenge
    code/code
    code/code_default
    code/code_with_all_features
    code/code_with_angle_brackets
    code/code_with_filename
    code/code_with_line_numbers
    code/code_with_no_line_numbers
    code/code_with_line_highlights
    collapse/collapse
    collapse/collapse_in_challenge
    collapse/collapse_music_box
    collapse/collapse_with_code
    collapse/collapse_with_space
    hint/hint
    hint/hints
    knowledge_quiz/example_question
    knowledge_quiz/question_blocks_in_feedback
    knowledge_quiz/question_single_feedback
    microbit/microbit
    new_page/new_page
    no_print/no_print
    print_only/print_only
    quiz/quiz
    save/save
    scratch/scratch2
    scratch/scratch3
    task/task
    task/task_with_hints
    task/task_with_ingredient
  ].freeze

  it 'has a version number' do
    expect(KramdownRPF::VERSION).not_to be nil
  end

  describe 'conversions' do
    CONVERSION_TESTS.each do |test_name|
      context test_name do
        reference_result = File.read "examples/#{test_name}.html"

        it 'should be correctly converted' do
          I18n.locale = 'en'

          test_result = Kramdown::Document.new(
            File.read("examples/#{test_name}.md"),
            KRAMDOWN_OPTIONS
          ).to_html

          expect(test_result.strip).to eq(reference_result.strip)
        end
      end
    end
  end
end
