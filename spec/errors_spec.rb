# frozen_string_literal: true

require 'spec_helper'

RSpec.describe KramdownRPF do
  KRAMDOWN_OPTIONS = {
    input: 'KramdownRPF',
    parse_block_html: true,
    syntax_highlighter: nil
  }.freeze

  describe 'with incomplete markup' do
    it 'should raise an exception' do
      I18n.locale = 'en'
      test_result = Kramdown::Document.new(
        File.read('examples/errors/collapse.md'),
        KRAMDOWN_OPTIONS
      )

      expect { test_result.to_html }.to raise_error(Kramdown::ParseError)
    end
  end

  describe 'with valid markup' do
    it 'should not raise any errors' do
      I18n.locale = 'en'
      test_result = Kramdown::Document.new(
        File.read('examples/collapse/collapse.md'),
        KRAMDOWN_OPTIONS
      )

      expect { test_result.to_html }.not_to raise_error
    end
  end
end
