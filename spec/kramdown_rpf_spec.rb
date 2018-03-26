require 'spec_helper'

RSpec.describe KramdownRPF do
  KRAMDOWN_OPTIONS = {
    input:              'KramdownRPF',
    parse_block_html:   true,
    syntax_highlighter: nil,
  }.freeze

  CONVERSION_TESTS = %w[
    challenge
    code
    code_with_filename
    code_with_line_numbers
    code_with_line_highlights
    collapse
    collapse_in_challenge
    collapse_music_box
    collapse_with_space
    hint
    hints
    save
    task
    task_with_hints
    task_with_ingredient
  ].freeze

  I18N_TESTS = %w[
    hints
    save
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

  describe 'i18n' do
    I18N_TESTS.each do |test_name|
      context test_name do
        reference_result = File.read "examples/i18n/#{test_name}.html"

        it 'should be correctly converted' do
          I18n.locale = 'xyz'

          test_result = Kramdown::Document.new(
            File.read("examples/i18n/#{test_name}.md"),
            KRAMDOWN_OPTIONS
          ).to_html

          expect(test_result.strip).to eq(reference_result.strip)
        end
      end
    end
  end
end
