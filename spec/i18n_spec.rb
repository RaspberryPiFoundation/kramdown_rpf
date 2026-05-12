# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'i18n' do
  let(:kramdown_options) do
    {
      input: 'KramdownRPF',
      parse_block_html: true,
      syntax_highlighter: nil
    }
  end

  locales_dir = File.join(File.absolute_path('../..', __FILE__), 'locales').freeze
  locales_files = File.join(locales_dir, '*.yml').freeze

  Dir.glob(locales_files).each do |file|
    file_contents = YAML.load_file(file).first
    locale = file_contents[0]
    values = file_contents[1]['kramdown_rpf']

    context("with #{locale} locale") do
      around do |example|
        I18n.locale = locale
        example.run
        I18n.locale = I18n.default_locale
      end

      it('converts hint title') do
        test_result = Kramdown::Document.new(
          File.read('examples/i18n/hints.md'),
          kramdown_options
        ).to_html

        expect(test_result).to(include(values['hint_title']))
      end

      it('converts save prompt') do
        test_result = Kramdown::Document.new(
          File.read('examples/i18n/save.md'),
          kramdown_options
        ).to_html

        expect(test_result).to(include(values['save']))
      end
    end
  end
end
