# frozen_string_literal: true

require_relative 'spec_helper'

SPEC_MD = ENV.fetch('SPEC_MD', nil)

# Parses spec.md and returns an array of:
#   { section: String, subsection: String|nil, number: Integer,
#     input: String, expected: String }
def parse_spec(path)
  content = File.read(path)
  examples = []
  section    = 'Unknown'
  subsection = nil
  number     = 0

  content.scan(/^((?:\#{1,6}) [^\n]+$)|^```+example\n(.*?)\n```+/m) do |heading, block|
    if heading
      level = heading.match(/^(#+)/)[1].length
      title = heading.sub(/^#+\s*/, '').strip
      if level <= 2
        section    = title
        subsection = nil
      else
        subsection = title
      end
    elsif block
      parts = block.split(/\n·\n/, 2)
      next unless parts.length == 2

      number += 1
      examples << {
        section: section,
        subsection: subsection,
        number: number,
        input: parts[0].strip,
        expected: parts[1].strip
      }
    end
  end

  examples
end

return if SPEC_MD.nil?

raise "Spec file not found: #{SPEC_MD}" unless File.exist?(SPEC_MD)


RSpec.describe "RPF Markdown Spec: #{File.basename(SPEC_MD)}" do
  examples = parse_spec(SPEC_MD)
  examples.group_by { |e| e[:section] }.each do |section, section_examples|
    context section do
      section_examples.group_by { |e| e[:subsection] }.each do |subsection, sub_examples|
        define_examples = lambda do
          sub_examples.each do |example|
            it "example #{example[:number]}" do
              actual = Kramdown::Document.new(example[:input], KRAMDOWN_OPTIONS).to_html
              expect(actual).to match_html(example[:expected])
            end
          end
        end

        if subsection
          context subsection, &define_examples
        else
          define_examples.call
        end
      end
    end
  end
end
