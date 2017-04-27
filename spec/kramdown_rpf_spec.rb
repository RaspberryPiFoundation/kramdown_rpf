require 'spec_helper'

RSpec.describe KramdownRPF do
  it 'has a version number' do
    expect(KramdownRPF::VERSION).not_to be nil
  end

  %w(challenge collapse hint).each do |test_name|
    context test_name do
      reference_result = File.read "examples/#{test_name}.html"

      it 'should be correctly converted' do
        test_result = Kramdown::Document.new(
          File.read("examples/#{test_name}.md"),
          parse_block_html: true,
          input: 'KramdownRPF'
        ).to_html
        expect(test_result.strip).to eq(reference_result.strip)
      end
    end
  end
end
