require 'spec_helper'

RSpec.describe KramdownRaspberryPi do
  it 'has a version number' do
    expect(KramdownRaspberryPi::VERSION).not_to be nil
  end

  %w(example_1).each do |test_name|
    context test_name do
      reference_result = File.read "examples/#{test_name}.html"

      it 'should be correctly converted' do
        test_result = Kramdown::Document.new(
          File.read("examples/#{test_name}.md"), parse_block_html: true
        ).to_html
        expect(test_result.chomp).to eq(reference_result.chomp)
      end
    end
  end
end
