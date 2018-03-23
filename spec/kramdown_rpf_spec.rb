require 'spec_helper'

RSpec.describe KramdownRPF do
  it 'has a version number' do
    expect(KramdownRPF::VERSION).not_to be nil
  end

  fdescribe 'conversions' do
    %w[
      challenge
      code
      code_with_filename
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
    ].each do |test_name|
      context test_name do
        reference_result = File.read "examples/#{test_name}.html"

        it 'should be correctly converted' do
          I18n.locale = 'en'

          test_result = Kramdown::Document.new(
            File.read("examples/#{test_name}.md"),
            parse_block_html: true,
            input: 'KramdownRPF'
          ).to_html

          expect(test_result.strip).to eq(reference_result.strip)
        end
      end
    end
  end

  describe 'i18n' do
    %w[
      hints
      save
    ].each do |test_name|
      context test_name do
        reference_result = File.read "examples/i18n/#{test_name}.html"

        it 'should be correctly converted' do
          I18n.locale = 'xyz'
          test_result = Kramdown::Document.new(
            File.read("examples/i18n/#{test_name}.md"),
            parse_block_html: true,
            input: 'KramdownRPF'
            ).to_html
          expect(test_result.strip).to eq(reference_result.strip)
        end
      end
    end
  end
end
