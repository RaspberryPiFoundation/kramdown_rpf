# frozen_string_literal: true

require 'spec_helper'

RSpec.describe KramdownRPF do
  let(:kramdown_options) do
    {
      input: 'KramdownRPF',
      parse_block_html: true,
      syntax_highlighter: nil
    }
  end

  describe 'with incomplete markup' do
    it 'raises an exception' do
      I18n.locale = 'en'
      test_result = Kramdown::Document.new(
        File.read('examples/errors/collapse.md'),
        kramdown_options
      )

      expect { test_result.to_html }.to raise_error(Kramdown::ParseError)
    end
  end

  describe 'with valid markup' do
    it 'does not raise any errors' do
      I18n.locale = 'en'
      test_result = Kramdown::Document.new(
        File.read('examples/collapse/collapse.md'),
        kramdown_options
      )

      expect { test_result.to_html }.not_to raise_error
    end
  end
end
