require 'spec_helper'

RSpec.describe 'i18n' do
  KRAMDOWN_OPTIONS = {
    input:              'KramdownRPF',
    parse_block_html:   true,
    syntax_highlighter: nil,
  }.freeze

  LOCALES_DIR = File.join(File.absolute_path('../..', __FILE__), 'locales').freeze
  LOCALES_FILES = File.join(LOCALES_DIR, '*.yml')
  LOCALES = {}

  Dir.glob(LOCALES_FILES).each do |file, contents|
    file_contents = YAML.load_file(file).first
    locale = file_contents[0]
    values = file_contents[1]['kramdown_rpf']

    context("with #{locale} locale") do
      before(:all) do
        I18n.locale = locale
      end

      it("should convert hint title") do
        test_result = Kramdown::Document.new(
          File.read("examples/i18n/hints.md"),
          KRAMDOWN_OPTIONS
        ).to_html

        expect(test_result).to(include(values['hint_title']))
      end

      it("should convert save prompt") do
        test_result = Kramdown::Document.new(
          File.read("examples/i18n/save.md"),
          KRAMDOWN_OPTIONS
        ).to_html

        expect(test_result).to(include(values['save']))
      end
    end
  end
end
