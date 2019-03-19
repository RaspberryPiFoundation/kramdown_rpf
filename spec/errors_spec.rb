require 'spec_helper'

RSpec.describe KramdownRPF do
  KRAMDOWN_OPTIONS = {
    input:              'KramdownRPF',
    parse_block_html:   true,
    syntax_highlighter: nil,
  }.freeze

  describe "with incomplete markup" do
    it 'detects bad markup tags' do
      I18n.locale = 'en'
      test_result = Kramdown::Document.new(
        File.read("examples/errors/collapse.md"),
        KRAMDOWN_OPTIONS
      ).to_html
      expect(RPF::Plugin::Kramdown.markup?(test_result)).to eq(true)
    end
  end

  describe "with valid markup" do
    it 'detects no markup tags' do
      I18n.locale = 'en'
      test_result = Kramdown::Document.new(
        File.read("examples/collapse/collapse.md"),
        KRAMDOWN_OPTIONS
      ).to_html

      expect(RPF::Plugin::Kramdown.markup?(test_result)).to eq(false)
    end
  end

end
