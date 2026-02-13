# frozen_string_literal: true

require 'spec_helper'

RSpec.describe KramdownRPF do
  conversion_tests = %w[
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
    expect(KramdownRPF::VERSION).not_to be_nil
  end

  describe 'conversions' do
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
end
