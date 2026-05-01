# frozen_string_literal: true

require 'bundler/setup'
require 'kramdown_rpf'
require 'compare-xml'
require 'nokogiri'
require 'diff/lcs'
require 'rspec/matchers'
require 'i18n'

I18n.locale = 'en'

KRAMDOWN_OPTIONS = {
  input: 'KramdownRPF',
  parse_block_html: true,
  syntax_highlighter: nil
}.freeze

def html_diff(actual_html, expected_html)
  actual_lines   = Nokogiri::HTML5.fragment(actual_html).to_xhtml.lines
  expected_lines = Nokogiri::HTML5.fragment(expected_html).to_xhtml.lines

  diffs = Diff::LCS.diff(actual_lines, expected_lines)
  return '' if diffs.empty?

  output = []
  diffs.each do |hunk|
    hunk.each do |change|
      prefix = change.action == '+' ? "\e[32m+" : "\e[31m-"
      output << "#{prefix} #{change.element.chomp}\e[0m"
    end
  end
  output.join("\n")
end

RSpec::Matchers.define :match_html do |expected_html, **options|
  match do |actual_html|
    @actual_html   = actual_html
    @expected_html = expected_html
    expected_doc   = Nokogiri::HTML5.fragment(expected_html)
    actual_doc     = Nokogiri::HTML5.fragment(actual_html)

    CompareXML.equivalent?(expected_doc, actual_doc, verbose: true, **options).empty?
  end

  failure_message do
    "HTML does not match.\n#{html_diff(@actual_html, @expected_html)}"
  end
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
