# frozen_string_literal: true

require 'spec_helper'

RSpec.describe KramdownRPF do
  it 'has a version number' do
    expect(KramdownRPF::VERSION).not_to be_nil
  end

  Dir.glob('spec/fixtures/*spec.md').each do |spec_file|
    it_behaves_like 'conforms to spec', spec_file
  end

  legacy_conversion_tests = %w[
    quiz/quiz
  ].freeze

  describe 'legacy conversions' do
    legacy_conversion_tests.each do |test_name|
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
          expect(test_result).to match_html(reference_result.strip)
        end
      end
    end
  end
end
