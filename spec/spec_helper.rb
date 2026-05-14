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

# Parses spec.md and returns an array of:
#   { section: String, subsection: String|nil, number: Integer,
#     input: String, expected: String }
def parse_spec(path)
  content = File.readlines(path).map(&:chomp)
  examples = []
  section    = 'Unknown'
  subsection = nil
  number     = 0

  in_example = false
  example_lines = []

  content.each do |line|
    if in_example && line == in_example
      in_example = false
      parts = example_lines.join("\n").split(/\n·\n/, 2)
      if parts.length == 2
        number += 1
        examples << {
          section: section,
          subsection: subsection,
          number: number,
          input: parts[0].strip,
          expected: parts[1].strip
        }
      end
    elsif in_example
      example_lines << line
    elsif line =~ /^(\#{1,6})\s*(.+)$/
      level = Regexp.last_match(1).length
      title = Regexp.last_match(2).strip
      if level <= 2
        section    = title
        subsection = nil
      else
        subsection = title
      end
    elsif line.strip =~ /^(```+)example$/
      in_example = Regexp.last_match(1)
      example_lines = []
    end
  end

  examples
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
