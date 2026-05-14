# frozen_string_literal: true

require 'spec_helper'

RFM_SPEC_MD = ENV.fetch('RFM_SPEC_MD', 'spec/rfm_spec.md')

raise "Spec file not found: #{RFM_SPEC_MD}" unless File.exist?(RFM_SPEC_MD)

RSpec.describe "RPF Markdown Spec: #{File.basename(RFM_SPEC_MD)}" do # rubocop:disable RSpec/DescribeClass
  examples = parse_spec(RFM_SPEC_MD)
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
