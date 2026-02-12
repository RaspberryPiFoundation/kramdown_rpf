# frozen_string_literal: true

require 'spec_helper'

RSpec.describe KramdownRPF do
  it 'has a version number' do
    expect(KramdownRPF::VERSION).not_to be_nil
  end

  conversion_tests = Dir.glob('examples/**/*.html').select do |f|
    File.exist?(f.sub('.html', '.md'))
  end

  shared_examples 'a successful conversion' do |test_name|
    subject(:test_result) do
      Kramdown::Document.new(
        File.read(test_name.sub('.html', '.md')),
        input: 'KramdownRPF',
        parse_block_html: true,
        syntax_highlighter: nil
      ).to_html.strip
    end

    let(:reference_result) { File.read(test_name).strip }

    before { I18n.locale = :en }

    it 'produces the expected HTML output' do
      expect(test_result).to eq(reference_result)
    end
  end

  conversion_tests.each do |test_name|
    context "when converting #{test_name.sub('.html', '.md')}" do
      it_behaves_like 'a successful conversion', test_name
    end
  end
end
