# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'KramdownRPF' do
  let(:kramdown_options) do {
  }
  end

  locales_dir = File.join(File.absolute_path('../..', __FILE__), 'locales').freeze
  locales_files = File.join(locales_dir, '*.yml').freeze

  shared_examples 'i18n' do |locale, values|
    context("with #{locale} locale") do
      subject(:test_result) do
        Kramdown::Document.new(
          File.read(test_name),
          input: 'KramdownRPF',
          parse_block_html: true,
          syntax_highlighter: nil
        ).to_html
      end

      before do
        I18n.locale = locale
      end

      context('with hint title') do
        let(:test_name) { 'examples/i18n/hint.md' }

        it('converts hint title') do
        expect(test_result).to(include(values['hint_title']))
      end

      context ('with save prompt') do
        let(:test_name) { 'examples/i18n/save.md' }

        it('converts save prompt') do
          expect(test_result).to(include(values['save']))
        end
      end
    end
  end


  Dir.glob(locales_files).each do |file|
    file_contents = YAML.load_file(file).first
    locale = file_contents[0]
    values = file_contents[1]['kramdown_rpf']

    it_behaves_like 'i18n', locale, values
  end
end
