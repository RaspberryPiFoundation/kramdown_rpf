# frozen_string_literal: true

require 'spec_helper'

LEGACY_SPEC_MD = ENV.fetch('LEGACY_SPEC_MD', 'spec/kramdown_rpf-legacy-spec.md')

raise "Spec file not found: #{LEGACY_SPEC_MD}" unless File.exist?(LEGACY_SPEC_MD)

RSpec.describe "RPF Markdown Spec: #{File.basename(LEGACY_SPEC_MD)}" do # rubocop:disable RSpec/DescribeClass
  examples = parse_spec(LEGACY_SPEC_MD)
  examples.group_by { |e| e[:section] }.each do |section, section_examples|
    context section do # rubocop:disable RSpec/EmptyExampleGroup
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
